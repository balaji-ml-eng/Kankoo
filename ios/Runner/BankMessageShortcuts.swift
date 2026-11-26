import AppIntents
import Flutter
import Foundation

enum ShortcutInbox {
    static let enabledKey = "kankoo.shortcuts.enabled"
    static let errorKey = "kankoo.shortcuts.lastError"
    static let changed = Notification.Name("KankooShortcutInboxChanged")
    static let store = MessageInbox(
        directory: FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("KankooShortcutInbox", isDirectory: true),
        keyStore: InboxKeychain(service: "com.kankoo.kankoo.shortcut-inbox"))
    static var enabled: Bool { UserDefaults.standard.bool(forKey: enabledKey) }
}

struct ForwardBankMessageIntent: AppIntent {
    static var title: LocalizedStringResource = "Forward bank message"
    static var description = IntentDescription("Save a bank message to Kankoo's encrypted inbox. Open and unlock Kankoo to import it.")
    static var openAppWhenRun: Bool = false
    // Captures new encrypted input only. Reading/importing still requires the
    // normal foreground app and its app-lock checks.
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    @Parameter(title: "Bank message", description: "Select the Content of the Message automation's Shortcut Input.")
    var message: String
    @Parameter(title: "Sender", description: "Optional bank sender from Shortcut Input.")
    var sender: String?

    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard ShortcutInbox.enabled else { throw ShortcutSetupError.notEnabled }
        try await ShortcutInbox.store.enqueue(text: message, sender: sender)
        NotificationCenter.default.post(name: ShortcutInbox.changed, object: nil)
        return .result(dialog: "Saved to Kankoo's encrypted inbox. Open and unlock Kankoo to import it.")
    }
}

enum ShortcutSetupError: Error, LocalizedError {
    case notEnabled, invalidIdentifier
    var errorDescription: String? {
        switch self {
        case .notEnabled: return "Open Kankoo > Settings > iPhone Shortcuts and enable forwarding first."
        case .invalidIdentifier: return "The forwarding record identifier is invalid."
        }
    }
}

struct KankooAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: ForwardBankMessageIntent(),
            phrases: ["Forward a bank message to \(.applicationName)"],
            shortTitle: "Forward bank message", systemImageName: "tray.and.arrow.down")
    }
}

@MainActor
final class ShortcutInboxBridge {
    private let channel: FlutterMethodChannel
    private var observer: NSObjectProtocol?
    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "kankoo/shortcuts", binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in self?.handle(call, result: result) }
        observer = NotificationCenter.default.addObserver(forName: ShortcutInbox.changed, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor [weak self] in self?.channel.invokeMethod("pending", arguments: nil) }
        }
    }
    deinit { if let observer { NotificationCenter.default.removeObserver(observer) } }
    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task { @MainActor in
            do {
                switch call.method {
                case "status":
                    var status: [String: Any] = ["enabled": ShortcutInbox.enabled, "pendingCount": try await ShortcutInbox.store.pendingCount()]
                    if let error = UserDefaults.standard.string(forKey: ShortcutInbox.errorKey) { status["lastError"] = error }
                    result(status)
                case "setEnabled":
                    guard let enabled = call.arguments as? Bool else { throw ShortcutSetupError.notEnabled }
                    if enabled { try await ShortcutInbox.store.prepare() }
                    UserDefaults.standard.set(enabled, forKey: ShortcutInbox.enabledKey)
                    UserDefaults.standard.removeObject(forKey: ShortcutInbox.errorKey)
                    result(nil)
                case "enqueue":
                    guard ShortcutInbox.enabled else { throw ShortcutSetupError.notEnabled }
                    guard let arguments = call.arguments as? [String: Any], let text = arguments["text"] as? String else { throw InboxError.invalidMessage }
                    try await ShortcutInbox.store.enqueue(text: text, sender: arguments["sender"] as? String)
                    result(nil)
                case "pending":
                    let batch = try await ShortcutInbox.store.pending()
                    result(["items": batch.items.map { event in
                        var data: [String: Any] = ["id": event.id.uuidString.lowercased(), "text": event.text, "receivedAt": event.receivedAtMillis]
                        if let sender = event.sender { data["sender"] = sender }
                        return data
                    }, "unreadableCount": batch.unreadableCount, "pendingCount": batch.pendingCount])
                case "acknowledge":
                    guard let text = call.arguments as? String, let id = UUID(uuidString: text) else { throw ShortcutSetupError.invalidIdentifier }
                    try await ShortcutInbox.store.acknowledge(id)
                    result(nil)
                default: result(FlutterMethodNotImplemented)
                }
            } catch {
                result(FlutterError(code: "SHORTCUT_INBOX", message: error.localizedDescription, details: nil))
            }
        }
    }
}

enum ShortcutURLForwarder {
    static func accepts(_ url: URL) -> Bool { url.scheme?.lowercased() == "kankoo" && url.host?.lowercased() == "ingest" }
    static func decode(_ url: URL) throws -> (text: String, sender: String?) {
        guard accepts(url), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { throw InboxError.invalidMessage }
        var fields: [String: String] = [:]
        for pair in (components.percentEncodedQuery ?? "").split(separator: "&") {
            let parts = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            guard parts.count == 2,
                  let key = String(parts[0]).replacingOccurrences(of: "+", with: " ").removingPercentEncoding,
                  let value = String(parts[1]).replacingOccurrences(of: "+", with: " ").removingPercentEncoding,
                  fields[key] == nil else { throw InboxError.invalidMessage }
            fields[key] = value
        }
        guard let text = fields["text"], !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw InboxError.invalidMessage }
        return (text, fields["sender"])
    }
    /// Called natively for both cold and warm scene URLs, before Flutter routing.
    static func capture(_ url: URL) {
        guard accepts(url) else { return }
        Task {
            do {
                guard ShortcutInbox.enabled else { throw ShortcutSetupError.notEnabled }
                let fields = try decode(url)
                try await ShortcutInbox.store.enqueue(text: fields.text, sender: fields.sender)
                UserDefaults.standard.removeObject(forKey: ShortcutInbox.errorKey)
            } catch {
                UserDefaults.standard.set(error.localizedDescription, forKey: ShortcutInbox.errorKey)
            }
            NotificationCenter.default.post(name: ShortcutInbox.changed, object: nil)
        }
    }
}
