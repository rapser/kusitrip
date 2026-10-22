import Foundation

struct RegisterUseCase: Sendable {
    static let minimumPasswordLength = 8

    private let repository: any AuthRepositoryProtocol

    init() {
        self.repository = AuthRepositoryImpl()
    }

    init(repository: any AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        name: String,
        surname: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> User {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !name.isEmpty, !surname.isEmpty, !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyFields
        }
        guard email.contains("@"), email.contains(".") else { throw AuthError.invalidEmail }
        guard password.count >= Self.minimumPasswordLength else { throw AuthError.passwordTooShort }
        guard password == passwordConfirmation else { throw AuthError.passwordsDoNotMatch }

        return try await repository.register(name: name, surname: surname, email: email, password: password)
    }
}
