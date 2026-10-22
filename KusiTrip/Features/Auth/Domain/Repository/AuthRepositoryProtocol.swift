import Foundation

protocol AuthRepositoryProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
    func register(name: String, surname: String, email: String, password: String) async throws -> User
    func logout() async
    /// Restores the user from the session stored in the Keychain, if it is still valid.
    func restoreSession() async -> User?
}
