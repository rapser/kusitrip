import Foundation

struct ActivityDTO: Sendable {
    let id: String
    let title: String
    let descriptionText: String
    let price: Double
    let originalPrice: Double?
    let rating: Double
    let reviewCount: Int
    let travelerCount: Int
    let categoryId: String
    let destinationId: String
    let imageURLs: [String]
    let durationMinutes: Int
    let language: String
    let cancellationDays: Int
    let isFree: Bool
    let meetingPoint: String
    let includes: [String]
}
