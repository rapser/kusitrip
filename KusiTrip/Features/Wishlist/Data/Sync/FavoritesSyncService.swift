import Foundation
import SwiftData

/// Keeps the SwiftData wishlist (instant, works offline) in sync with the
/// user's favorites on the API. Views keep toggling SwiftData directly and
/// announce it with `.favoriteToggled`; this service mirrors it remotely.
final class FavoritesSyncService {
    private let repository: any FavoritesRepositoryProtocol
    private let modelContext: ModelContext

    init(modelContext: ModelContext, repository: any FavoritesRepositoryProtocol = FavoritesRepositoryImpl()) {
        self.modelContext = modelContext
        self.repository = repository
    }

    func handle(_ event: AppEvent) async {
        switch event {
        case .loginSuccess:
            await pullFromServer()
        case .logoutRequested, .sessionExpired:
            replaceLocalFavorites(with: [])
        case .favoriteToggled(let activityId, let isFavorite):
            await push(activityId: activityId, isFavorite: isFavorite)
        default:
            break
        }
    }

    /// The server is the source of truth once the user is logged in.
    func pullFromServer() async {
        guard let activities = try? await repository.fetchFavorites() else { return }
        replaceLocalFavorites(with: activities.map { ActivityMapper.toUI(entity: $0) })
    }

    private func push(activityId: String, isFavorite: Bool) async {
        do {
            if isFavorite {
                try await repository.addFavorite(activityId: activityId)
            } else {
                try await repository.removeFavorite(activityId: activityId)
            }
        } catch {
            // Undo the optimistic local change so the UI matches the server.
            await pullFromServer()
        }
    }

    private func replaceLocalFavorites(with activities: [ActivityUI]) {
        try? modelContext.delete(model: FavoriteModel.self)
        for activity in activities {
            modelContext.insert(
                FavoriteModel(
                    activityId: activity.id,
                    activityTitle: activity.title,
                    activityImageURL: activity.primaryImageURL,
                    activityPrice: activity.formattedPrice
                )
            )
        }
        try? modelContext.save()
    }
}
