import Foundation

nonisolated struct DestinationDTO: Decodable, Sendable {
    let id: String
    let name: String
    let country: String
    let continent: String
    let imageUrl: String
    let activityCount: Int
    let travelerCount: Int
    let reviewCount: Int
    let rating: Double
    let description: String
}
