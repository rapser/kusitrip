import Foundation

@MainActor
@Observable
final class AppCoordinator {
    var isAuthenticated: Bool = false
    var currentUser: UserUI?
    var isLoggingOut: Bool = false

    private let endSession: @MainActor () -> Void

    init(endSession: @escaping @MainActor () -> Void = { AppDependencies.shared.authSession.end() }) {
        self.endSession = endSession
    }

    func handle(event: AppEvent) {
        switch event {
        case .loginSuccess(let userUI):
            currentUser = userUI
            isAuthenticated = true
        case .logoutStarted:
            isLoggingOut = true
        case .logoutRequested:
            currentUser = nil
            isAuthenticated = false
            isLoggingOut = false
        case .sessionExpired:
            endSession()
            currentUser = nil
            isAuthenticated = false
            isLoggingOut = false
        default:
            break
        }
    }
}
