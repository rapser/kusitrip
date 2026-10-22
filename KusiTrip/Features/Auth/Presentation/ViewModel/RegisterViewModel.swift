import Foundation

@MainActor
@Observable
final class RegisterViewModel {
    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirmation: String = ""
    var isLoading: Bool = false
    var errorMessage: String?

    private let registerUseCase: RegisterUseCase

    init() {
        self.registerUseCase = RegisterUseCase()
    }

    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }

    func register() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let user = try await registerUseCase.execute(
                name: name,
                surname: surname,
                email: email,
                password: password,
                passwordConfirmation: passwordConfirmation
            )
            await EventBus.shared.send(.loginSuccess(userUI: UserMapper.toUI(entity: user)))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
