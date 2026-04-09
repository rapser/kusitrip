import Foundation

struct LoginUseCase: Sendable {
    private let repository: any AuthRepositoryProtocol

    init() {
        self.repository = AuthRepositoryImpl()
    }

    init(repository: any AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> User {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty, !password.isEmpty else {
            throw AuthError.emptyFields
        }
        return try await repository.login(email: trimmed, password: password)
    }
}
