import Foundation

@MainActor
@Observable
final class AppCoordinator {
    var isAuthenticated: Bool = false
    var currentUser: UserUI?

    func handle(event: AppEvent) {
        switch event {
        case .loginSuccess(let userUI):
            currentUser = userUI
            isAuthenticated = true
        case .logoutRequested:
            currentUser = nil
            isAuthenticated = false
        default:
            break
        }
    }
}
