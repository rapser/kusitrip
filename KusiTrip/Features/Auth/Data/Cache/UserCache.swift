import Foundation

/// Last known profile of the logged-in user. Lets the app open straight into
/// the tabs on launch while `GET /auth/me` validates the session in the background.
nonisolated protocol UserCache: Sendable {
    func load() -> UserDTO?
    func save(_ user: UserDTO)
    func clear()
}

nonisolated struct KeychainUserCache: UserCache {
    private let keychain = KeychainStore<UserDTO>(service: "com.rapser.kusitrip.auth", account: "user")

    func load() -> UserDTO? { keychain.load() }
    func save(_ user: UserDTO) { keychain.save(user) }
    func clear() { keychain.clear() }
}
