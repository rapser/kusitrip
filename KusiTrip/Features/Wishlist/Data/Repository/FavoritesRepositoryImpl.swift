import Foundation

struct FavoritesRepositoryImpl: FavoritesRepositoryProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = AppDependencies.shared.apiClient) {
        self.apiClient = apiClient
    }

    func fetchFavorites() async throws -> [Activity] {
        let dtos = try await apiClient.send(.favorites, as: [ActivityDTO].self)
        return dtos.map { ActivityMapper.toDomain(dto: $0) }
    }

    func addFavorite(activityId: String) async throws {
        try await apiClient.send(.addFavorite(activityId: activityId))
    }

    func removeFavorite(activityId: String) async throws {
        do {
            try await apiClient.send(.removeFavorite(activityId: activityId))
        } catch APIError.server(code: "FAVORITE_NOT_FOUND", _, _) {
            // Already gone on the server: nothing to do.
        }
    }
}
