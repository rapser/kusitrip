import Foundation

@MainActor
@Observable
final class ProfileViewModel {
    var currentUser: UserUI?
    var isLoggingOut: Bool = false

    private let logoutUseCase: LogoutUseCase

    init() {
        self.logoutUseCase = LogoutUseCase()
    }

    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }

    func setup(user: UserUI?) {
        currentUser = user
    }

    func logout() async {
        isLoggingOut = true
        await logoutUseCase.execute()
        isLoggingOut = false
    }
}
