import Foundation

struct LogoutUseCase: Sendable {
    private let repository: any AuthRepositoryProtocol

    init() {
        self.repository = AuthRepositoryImpl()
    }

    init(repository: any AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async {
        await repository.logout()
        await EventBus.shared.send(.logoutRequested)
    }
}
