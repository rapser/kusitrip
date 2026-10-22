import Foundation

struct GetHomeDataUseCase: Sendable {
    private let repository: any HomeRepositoryProtocol

    init() {
        self.repository = HomeRepositoryImpl()
    }

    init(repository: any HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> HomeData {
        let home = try await repository.fetchHome()
        return HomeData(
            destinations: home.destinations,
            featuredActivities: home.featuredActivities,
            categories: [.all] + home.categories
        )
    }
}
