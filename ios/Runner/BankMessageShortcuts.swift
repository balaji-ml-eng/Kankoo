import AppIntents
import Flutter
import Foundation

enum ShortcutInbox {
    static let enabledKey = "kankoo.shortcuts.enabled"
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
                    result(["enabled": ShortcutInbox.enabled, "pendingCount": try await ShortcutInbox.store.pendingCount()])
                case "setEnabled":
                    guard let enabled = call.arguments as? Bool else { throw ShortcutSetupError.notEnabled }
                    if enabled { try await ShortcutInbox.store.prepare() }
                    UserDefaults.standard.set(enabled, forKey: ShortcutInbox.enabledKey)
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
