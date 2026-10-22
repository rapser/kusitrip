import Foundation

struct ReviewUI: Sendable, Identifiable, Hashable {
    let id: String
    let activityId: String
    let authorName: String
    let initials: String
    let city: String
    let ratingText: String
    let comment: String
    let date: String
    let travelTypeLabel: String
    let travelTypeIcon: String
}
