import Foundation

nonisolated protocol TokenStore: Sendable {
    func load() -> AuthCredential?
    func save(_ credential: AuthCredential)
    func clear()
}

/// Persists the session tokens in the Keychain (never in UserDefaults).
nonisolated final class KeychainTokenStore: TokenStore {
    private let keychain = KeychainStore<AuthCredential>(service: "com.rapser.kusitrip.auth", account: "session")

    func load() -> AuthCredential? { keychain.load() }
    func save(_ credential: AuthCredential) { keychain.save(credential) }
    func clear() { keychain.clear() }
}
