import Foundation

nonisolated struct AddFavoriteRequestDTO: Encodable, Sendable {
    let activityId: String
}

extension Endpoint {
    nonisolated static let favorites = Endpoint(path: "favorites", requiresAuth: true)

    nonisolated static func addFavorite(activityId: String) -> Endpoint {
        Endpoint(
            path: "favorites",
            method: .post,
            body: AddFavoriteRequestDTO(activityId: activityId),
            requiresAuth: true
        )
    }

    nonisolated static func removeFavorite(activityId: String) -> Endpoint {
        Endpoint(path: "favorites/\(activityId)", method: .delete, requiresAuth: true)
    }
}
