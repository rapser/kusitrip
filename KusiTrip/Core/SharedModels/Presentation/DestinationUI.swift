import Foundation

struct DestinationUI: Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let continent: String
    let imageURL: String
    let activityCountText: String
    let travelerCountText: String
    let reviewCountText: String
    let ratingText: String
    let description: String
}
