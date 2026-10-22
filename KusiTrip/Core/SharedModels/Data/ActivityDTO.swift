import Foundation

nonisolated struct ActivityDTO: Decodable, Sendable {
    let id: String
    let title: String
    let summary: String
    let description: String
    let price: Double
    let originalPrice: Double?
    let currency: String
    let rating: Double
    let reviewCount: Int
    let travelerCount: Int
    let category: CategoryDTO
    let destinationId: String
    let imageUrls: [String]
    let durationMinutes: Int
    let language: String
    let freeCancellationDays: Int
    let isFree: Bool
    let isFeatured: Bool
    let meetingPoint: String
    let includes: [String]
}

nonisolated struct ActivityPageDTO: Decodable, Sendable {
    struct Meta: Decodable, Sendable {
        let page: Int
        let limit: Int
        let total: Int
        let hasNext: Bool
    }

    let items: [ActivityDTO]
    let meta: Meta
}
