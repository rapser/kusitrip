import Foundation

struct SearchRepositoryImpl: SearchRepositoryProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = AppDependencies.shared.apiClient) {
        self.apiClient = apiClient
    }

    func search(query: String) async throws -> SearchResult {
        let dto = try await apiClient.send(.search(query: query), as: SearchDTO.self)
        return SearchResult(
            activities: dto.activities.map { ActivityMapper.toDomain(dto: $0) },
            destinations: dto.destinations.map { DestinationMapper.toDomain(dto: $0) }
        )
    }
}
