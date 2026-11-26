import AppIntents
import XCTest
@testable import Runner

final class RunnerTests: XCTestCase {
    func testNativeActionRequiresOptInAndPersistsUsingRealKeychain() async throws {
        let previous = UserDefaults.standard.object(forKey: ShortcutInbox.enabledKey)
        defer {
            if let previous { UserDefaults.standard.set(previous, forKey: ShortcutInbox.enabledKey) }
            else { UserDefaults.standard.removeObject(forKey: ShortcutInbox.enabledKey) }
        }
        UserDefaults.standard.set(false, forKey: ShortcutInbox.enabledKey)
        var intent = ForwardBankMessageIntent()
        let message = "SIMULATOR TEST \(UUID().uuidString): Rs.250 debited from HDFC Bank account."
        intent.message = message
        intent.sender = "TEST-HDFC"
        do {
            _ = try await intent.perform()
            XCTFail("Forwarding must require explicit opt-in")
        } catch ShortcutSetupError.notEnabled {} catch { throw error }
        try await ShortcutInbox.store.prepare()
        UserDefaults.standard.set(true, forKey: ShortcutInbox.enabledKey)
        _ = try await intent.perform()
        let first = try await ShortcutInbox.store.pending()
        let event = try XCTUnwrap(first.items.first { $0.text == message })
        XCTAssertEqual(event.sender, "TEST-HDFC")
        let second = try await ShortcutInbox.store.pending()
        XCTAssertTrue(second.items.contains { $0.id == event.id })
        try await ShortcutInbox.store.acknowledge(event.id)
        let final = try await ShortcutInbox.store.pending()
        XCTAssertFalse(final.items.contains { $0.id == event.id })
    }

    func testLegacyURLPreservesEncodedCurrencyAndRejectsAmbiguity() throws {
        let fields = try ShortcutURLForwarder.decode(URL(string: "kankoo://ingest?text=Rs+250%2B+debited%0ARef%3D123&sender=TEST%26BANK")!)
        XCTAssertEqual(fields.text, "Rs 250+ debited\nRef=123")
        XCTAssertEqual(fields.sender, "TEST&BANK")
        for raw in ["kankoo://ingest?text=one&text=two", "kankoo://ingest?text=", "https://ingest?text=hello"] {
            XCTAssertThrowsError(try ShortcutURLForwarder.decode(URL(string: raw)!))
        }
        XCTAssertFalse(ShortcutURLForwarder.accepts(URL(string: "com.google.oauth://callback")!))
    }
}
