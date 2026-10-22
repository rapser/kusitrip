import Foundation
import SwiftData

@Model
final class FavoriteModel {
    @Attribute(.unique) var activityId: String
    var activityTitle: String
    var activityImageURL: String
    var activityPrice: String
    var savedAt: Date

    init(activityId: String, activityTitle: String, activityImageURL: String, activityPrice: String) {
        self.activityId       = activityId
        self.activityTitle    = activityTitle
        self.activityImageURL = activityImageURL
        self.activityPrice    = activityPrice
        self.savedAt          = Date()
    }
}
