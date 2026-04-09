import Foundation

struct GetHomeDataUseCase: Sendable {
    private let repository: any HomeRepositoryProtocol

    init() {
        self.repository = HomeRepositoryImpl()
    }

    init(repository: any HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> HomeData {
        HomeData(
            destinations: repository.fetchDestinations(),
            featuredActivities: repository.fetchFeaturedActivities(),
            categories: repository.fetchCategories()
        )
    }
}
