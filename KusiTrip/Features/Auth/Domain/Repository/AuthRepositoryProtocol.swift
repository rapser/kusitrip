import Foundation

protocol AuthRepositoryProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
    func register(name: String, surname: String, email: String, password: String) async throws -> User
    /// Ends the session on this device at once; the API is notified in the background.
    func logout() async
    /// User of the stored session, read locally without calling the API.
    func cachedUser() -> User?
    /// Validates the stored session with the API and returns the up-to-date user.
    func restoreSession() async -> User?
}
