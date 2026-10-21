import Foundation
import SwiftData

extension ModelContext {
    /// Adds the activity to favorites, or removes it if it was already saved.
    /// Returns whether the activity is a favorite after the toggle.
    @discardableResult
    func toggleFavorite(_ activity: ActivityUI) -> Bool {
        let activityId = activity.id
        let descriptor = FetchDescriptor<FavoriteModel>(
            predicate: #Predicate { $0.activityId == activityId }
        )
        if let existing = try? fetch(descriptor).first {
            delete(existing)
            return false
        }
        insert(
            FavoriteModel(
                activityId: activity.id,
                activityTitle: activity.title,
                activityImageURL: activity.primaryImageURL,
                activityPrice: activity.formattedPrice
            )
        )
        return true
    }
}
