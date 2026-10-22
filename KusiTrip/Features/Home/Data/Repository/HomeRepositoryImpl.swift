import Foundation

struct HomeRepositoryImpl: HomeRepositoryProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = AppDependencies.shared.apiClient) {
        self.apiClient = apiClient
    }

    func fetchHome() async throws -> HomeData {
        let dto = try await apiClient.send(.home, as: HomeDTO.self)
        return HomeData(
            destinations: dto.destinations.map { DestinationMapper.toDomain(dto: $0) },
            featuredActivities: dto.featuredActivities.map { ActivityMapper.toDomain(dto: $0) },
            categories: dto.categories.map { CategoryMapper.toDomain(dto: $0) }
        )
    }
}
