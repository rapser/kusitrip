import Foundation

struct Review: Sendable, Identifiable, Hashable {
    let id: String
    let activityId: String
    let authorName: String
    let city: String
    let rating: Double
    let comment: String
    let date: String
    let travelType: String
}
