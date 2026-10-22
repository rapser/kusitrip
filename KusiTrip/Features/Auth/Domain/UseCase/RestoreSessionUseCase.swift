import Foundation

struct RestoreSessionUseCase: Sendable {
    private let repository: any AuthRepositoryProtocol

    init() {
        self.repository = AuthRepositoryImpl()
    }

    init(repository: any AuthRepositoryProtocol) {
        self.repository = repository
    }

    /// User of the stored session, available instantly (no network).
    func cachedUser() -> User? {
        repository.cachedUser()
    }

    /// Returns the user of the session stored in the Keychain, if it is still valid.
    func execute() async -> User? {
        await repository.restoreSession()
    }
}
