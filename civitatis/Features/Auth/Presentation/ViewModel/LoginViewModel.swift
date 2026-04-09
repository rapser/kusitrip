import Foundation

@MainActor
@Observable
final class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var showPassword: Bool = false

    private let loginUseCase: LoginUseCase

    init() {
        self.loginUseCase = LoginUseCase()
    }

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = AuthError.emptyFields.errorDescription
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let user = try await loginUseCase.execute(email: email, password: password)
            let userUI = UserMapper.toUI(entity: user)
            await EventBus.shared.send(.loginSuccess(userUI: userUI))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
