import CryptoKit
import Foundation
import Security

public enum InboxError: Error, LocalizedError {
    case invalidMessage, full, keyUnavailable, keyStorage, invalidFile, conflictingEvent

    public var errorDescription: String? {
        switch self {
        case .invalidMessage: return "Use a non-empty bank message up to 32 KB and a sender up to 512 bytes."
        case .full: return "Kankoo's encrypted inbox is full. Open and unlock Kankoo, then retry forwarding."
        case .keyUnavailable: return "The encrypted inbox key is unavailable. Unlock the iPhone after restarting and retry. Existing files were kept."
        case .keyStorage: return "The iPhone could not save the inbox key. No message was stored."
        case .invalidFile: return "An encrypted inbox record could not be authenticated. Its file was kept."
        case .conflictingEvent: return "This forwarding identifier already contains a different message."
        }
    }
}

public protocol InboxKeyStore: Sendable {
    func read() throws -> Data?
    func createIfAbsent(_ candidate: Data) throws -> Data
}

public struct InboxKeychain: InboxKeyStore {
    private let service: String
    public init(service: String) { self.service = service }
    private var query: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service, kSecAttrAccount as String: "shortcut-inbox-v1",
         kSecAttrSynchronizable as String: false]
    }
    public func read() throws -> Data? {
        var query = query
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = result as? Data, data.count == 32 else {
            throw InboxError.keyUnavailable
        }
        return data
    }
    public func createIfAbsent(_ candidate: Data) throws -> Data {
        var attributes = query
        attributes[kSecValueData as String] = candidate
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status == errSecSuccess { return candidate }
        if status == errSecDuplicateItem, let existing = try read() { return existing }
        throw InboxError.keyStorage
    }
}

public struct ForwardedBankMessage: Codable, Equatable, Sendable {
    public let version: Int
    public let id: UUID
    public let text: String
    public let sender: String?
    public let receivedAtMillis: Int64
}

public struct InboxBatch: Sendable {
    public let items: [ForwardedBankMessage]
    public let unreadableCount: Int
    public let pendingCount: Int
}

/// Owns ciphertext files only. Acknowledgment is separate from reading so a
/// Flutter crash between DB commit and ack replays the same stable event ID.
public actor MessageInbox {
    public static let maxMessageBytes = 32 * 1024
    private static let magic = Data("KSI1".utf8)
    private let directory: URL
    private let keyStore: any InboxKeyStore
    private let maxEvents: Int
    private let fileManager = FileManager.default

    public init(directory: URL, keyStore: any InboxKeyStore, maxEvents: Int = 500) {
        self.directory = directory
        self.keyStore = keyStore
        self.maxEvents = maxEvents
    }
    private func files() throws -> [URL] {
        guard fileManager.fileExists(atPath: directory.path) else { return [] }
        return try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "kq" }
    }
    private func prepareDirectory() throws {
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        var folder = directory
        try folder.setResourceValues(resourceValues)
        #if os(iOS)
        try fileManager.setAttributes([.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], atPath: directory.path)
        #endif
    }
    private func key(create: Bool) throws -> SymmetricKey {
        if let existing = try keyStore.read() {
            guard existing.count == 32 else { throw InboxError.keyUnavailable }
            return SymmetricKey(data: existing)
        }
        guard create, try files().isEmpty else { throw InboxError.keyUnavailable }
        var bytes = Data(count: 32)
        let status = bytes.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!) }
        guard status == errSecSuccess else { throw InboxError.keyStorage }
        let saved = try keyStore.createIfAbsent(bytes)
        guard saved.count == 32 else { throw InboxError.keyStorage }
        return SymmetricKey(data: saved)
    }
    public func prepare() throws {
        try prepareDirectory()
        _ = try key(create: true)
    }
    private func url(_ id: UUID) -> URL {
        directory.appendingPathComponent(id.uuidString.lowercased()).appendingPathExtension("kq")
    }
    private func aad(_ id: UUID) -> Data { Data("kankoo-shortcut-inbox:v1:\(id.uuidString.lowercased())".utf8) }
    private func open(_ file: URL, key: SymmetricKey) throws -> ForwardedBankMessage {
        guard let id = UUID(uuidString: file.deletingPathExtension().lastPathComponent),
              let size = (try file.resourceValues(forKeys: [.fileSizeKey])).fileSize,
              size <= Self.maxMessageBytes * 6 + 4096 else { throw InboxError.invalidFile }
        let bytes = try Data(contentsOf: file)
        guard bytes.starts(with: Self.magic) else { throw InboxError.invalidFile }
        do {
            let box = try AES.GCM.SealedBox(combined: bytes.dropFirst(Self.magic.count))
            let clear = try AES.GCM.open(box, using: key, authenticating: aad(id))
            let event = try JSONDecoder().decode(ForwardedBankMessage.self, from: clear)
            guard event.version == 1, event.id == id else { throw InboxError.invalidFile }
            return event
        } catch { throw InboxError.invalidFile }
    }
    @discardableResult
    public func enqueue(text: String, sender: String?, receivedAt: Date = Date(), id: UUID = UUID()) throws -> UUID {
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sender = sender?.trimmingCharacters(in: .whitespacesAndNewlines)
        let millis = receivedAt.timeIntervalSince1970 * 1000
        guard !text.isEmpty, text.utf8.count <= Self.maxMessageBytes,
              (sender?.utf8.count ?? 0) <= 512, millis.isFinite, millis >= 0, millis < 4_134_067_200_000 else {
            throw InboxError.invalidMessage
        }
        let event = ForwardedBankMessage(version: 1, id: id, text: text,
            sender: sender?.isEmpty == false ? sender : nil, receivedAtMillis: Int64(millis))
        try prepareDirectory()
        let key = try key(create: true)
        let destination = url(id)
        if fileManager.fileExists(atPath: destination.path) {
            guard try open(destination, key: key) == event else { throw InboxError.conflictingEvent }
            return id
        }
        guard try files().count < maxEvents else { throw InboxError.full }
        let clear = try JSONEncoder().encode(event)
        let encrypted = try AES.GCM.seal(clear, using: key, authenticating: aad(id))
        guard let packed = encrypted.combined else { throw InboxError.invalidFile }
        try (Self.magic + packed).write(to: destination, options: .atomic)
        return id
    }
    public func pendingCount() throws -> Int { try files().count }
    public func pending() throws -> InboxBatch {
        let files = try files()
        if files.isEmpty { return InboxBatch(items: [], unreadableCount: 0, pendingCount: 0) }
        let key = try key(create: false)
        var items: [ForwardedBankMessage] = []
        var unreadable = 0
        for file in files {
            do { items.append(try open(file, key: key)) }
            catch { unreadable += 1 }
        }
        items.sort { $0.receivedAtMillis == $1.receivedAtMillis
            ? $0.id.uuidString < $1.id.uuidString : $0.receivedAtMillis < $1.receivedAtMillis }
        return InboxBatch(items: items, unreadableCount: unreadable, pendingCount: files.count)
    }
    public func acknowledge(_ id: UUID) throws {
        let file = url(id)
        if fileManager.fileExists(atPath: file.path) { try fileManager.removeItem(at: file) }
    }
}
