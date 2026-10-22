import Foundation

@MainActor
@Observable
final class AppCoordinator {
    var isAuthenticated: Bool = false
    var currentUser: UserUI?

    private let endSession: @MainActor () -> Void

    init(endSession: @escaping @MainActor () -> Void = { AppDependencies.shared.authSession.end() }) {
        self.endSession = endSession
    }

    func handle(event: AppEvent) {
        switch event {
        case .loginSuccess(let userUI):
            currentUser = userUI
            isAuthenticated = true
        case .logoutRequested:
            currentUser = nil
            isAuthenticated = false
        case .sessionExpired:
            endSession()
            currentUser = nil
            isAuthenticated = false
        default:
            break
        }
    }
}
