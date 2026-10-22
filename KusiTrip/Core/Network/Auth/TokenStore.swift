import Foundation
import Security

nonisolated protocol TokenStore: Sendable {
    func load() -> AuthCredential?
    func save(_ credential: AuthCredential)
    func clear()
}

/// Persists the session tokens in the Keychain (never in UserDefaults).
nonisolated final class KeychainTokenStore: TokenStore {
    private let service = "com.rapser.kusitrip.auth"
    private let account = "session"

    func load() -> AuthCredential? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(AuthCredential.self, from: data)
    }

    func save(_ credential: AuthCredential) {
        guard let data = try? JSONEncoder().encode(credential) else { return }
        clear()
        var query = baseQuery
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        SecItemAdd(query as CFDictionary, nil)
    }

    func clear() {
        SecItemDelete(baseQuery as CFDictionary)
    }

    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }
}
