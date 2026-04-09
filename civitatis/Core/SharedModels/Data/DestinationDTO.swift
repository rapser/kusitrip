import Foundation

struct DestinationDTO: Sendable {
    let id: String
    let name: String
    let country: String
    let continent: String
    let imageURL: String
    let activityCount: Int
    let travelerCount: Int
    let reviewCount: Int
    let rating: Double
    let description: String
}
