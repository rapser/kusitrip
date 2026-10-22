import Foundation

nonisolated struct ReviewDTO: Decodable, Sendable {
    let id: String
    let activityId: String
    let authorName: String
    let city: String
    let rating: Double
    let comment: String
    let travelType: String
    /// ISO-8601 date.
    let publishedAt: String
}
