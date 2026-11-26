import Foundation
import XCTest
@testable import ShortcutInboxCore

final class MemoryKeys: InboxKeyStore, @unchecked Sendable {
    var bytes: Data?
    var failWrites = false
    func read() throws -> Data? { bytes }
    func createIfAbsent(_ candidate: Data) throws -> Data {
        if failWrites { throw InboxError.keyStorage }
        if let bytes { return bytes }
        bytes = candidate
        return candidate
    }
}

final class MessageInboxTests: XCTestCase {
    var directory: URL!
    var keys: MemoryKeys!
    var inbox: MessageInbox!
    let message = "Rs.250.00 debited from account 1234 to TEST MERCHANT. Ref TEST123456."
    override func setUpWithError() throws {
        directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        keys = MemoryKeys()
        inbox = MessageInbox(directory: directory, keyStore: keys)
    }
    override func tearDownWithError() throws {
        if FileManager.default.fileExists(atPath: directory.path) { try FileManager.default.removeItem(at: directory) }
    }
    func testEncryptedRoundTripSurvivesNewInstanceAndReadDoesNotDelete() async throws {
        let id = try await inbox.enqueue(text: message, sender: "TESTBANK")
        let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        let bytes = try Data(contentsOf: XCTUnwrap(files.first))
        XCTAssertNil(bytes.range(of: Data(message.utf8)))
        let restarted = MessageInbox(directory: directory, keyStore: keys)
        let batch = try await restarted.pending()
        XCTAssertEqual(batch.items.first?.id, id)
        XCTAssertEqual(batch.items.first?.text, message)
        XCTAssertEqual(batch.pendingCount, 1)
        let again = try await restarted.pending()
        XCTAssertEqual(again.items, batch.items)
        try await restarted.acknowledge(id)
        let count = try await restarted.pendingCount()
        XCTAssertEqual(count, 0)
    }
    func testTamperingIsCountedAndFilePreservedWhileGoodMessagesRemainAvailable() async throws {
        let id = try await inbox.enqueue(text: message, sender: nil)
        let file = directory.appendingPathComponent(id.uuidString.lowercased()).appendingPathExtension("kq")
        var bytes = try Data(contentsOf: file)
        bytes[20] ^= 1
        try bytes.write(to: file)
        try await inbox.enqueue(text: "Another bank message", sender: nil)
        let batch = try await inbox.pending()
        XCTAssertEqual(batch.unreadableCount, 1)
        XCTAssertEqual(batch.items.count, 1)
        XCTAssertEqual(batch.pendingCount, 2)
        XCTAssertTrue(FileManager.default.fileExists(atPath: file.path))
    }
    func testMissingKeyCannotBeSilentlyReplaced() async throws {
        try await inbox.enqueue(text: message, sender: nil)
        keys.bytes = nil
        do { try await inbox.enqueue(text: "New message", sender: nil); XCTFail("Missing key must block a new write") }
        catch InboxError.keyUnavailable { }
        XCTAssertNil(keys.bytes)
        let count = try await inbox.pendingCount()
        XCTAssertEqual(count, 1)
    }
    func testCapacityAndKeyPersistenceFailureNeverWritePartialRecords() async throws {
        let limited = MessageInbox(directory: directory, keyStore: keys, maxEvents: 1)
        keys.failWrites = true
        do { try await limited.enqueue(text: message, sender: nil); XCTFail("Key must be persisted first") }
        catch InboxError.keyStorage { }
        var count = try await limited.pendingCount()
        XCTAssertEqual(count, 0)
        keys.failWrites = false
        try await limited.enqueue(text: message, sender: nil)
        do { try await limited.enqueue(text: "Second", sender: nil); XCTFail("Queue must reject overflow") }
        catch InboxError.full { }
        count = try await limited.pendingCount()
        XCTAssertEqual(count, 1)
    }
    func testSameEventIsIdempotentAndConflictsCannotOverwriteIt() async throws {
        let id = UUID(), date = Date(timeIntervalSince1970: 1_800_000_000)
        try await inbox.enqueue(text: message, sender: nil, receivedAt: date, id: id)
        try await inbox.enqueue(text: message, sender: nil, receivedAt: date, id: id)
        do { try await inbox.enqueue(text: "Different", sender: nil, receivedAt: date, id: id); XCTFail("Conflicting ID") }
        catch InboxError.conflictingEvent { }
        let batch = try await inbox.pending()
        XCTAssertEqual(batch.items.count, 1)
        XCTAssertEqual(batch.items.first?.text, message)
    }
    func testInvalidInputsAndEscapedBoundaryText() async throws {
        for invalid in ["   ", String(repeating: "x", count: MessageInbox.maxMessageBytes + 1)] {
            do { try await inbox.enqueue(text: invalid, sender: nil); XCTFail("Invalid input") }
            catch InboxError.invalidMessage { }
        }
        let escaped = "A" + String(repeating: "\u{0001}", count: MessageInbox.maxMessageBytes - 2) + "Z"
        try await inbox.enqueue(text: escaped, sender: nil)
        let batch = try await inbox.pending()
        XCTAssertEqual(batch.items.first?.text, escaped)
        XCTAssertEqual(batch.unreadableCount, 0)
    }
}
