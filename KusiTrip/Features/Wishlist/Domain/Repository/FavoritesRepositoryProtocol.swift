import Foundation

protocol FavoritesRepositoryProtocol: Sendable {
    func fetchFavorites() async throws -> [Activity]
    func addFavorite(activityId: String) async throws
    func removeFavorite(activityId: String) async throws
}
