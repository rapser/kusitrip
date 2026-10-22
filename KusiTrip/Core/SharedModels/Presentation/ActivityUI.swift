import Foundation

struct ActivityUI: Sendable, Identifiable, Hashable {
    let id: String
    let title: String
    let fullDescription: String
    let formattedPrice: String
    let formattedOriginalPrice: String?
    let discountPercentage: Int?
    let ratingValue: Double
    let ratingText: String
    let reviewCountText: String
    let travelerCountText: String
    let primaryImageURL: String
    let imageURLs: [String]
    let categoryLabel: String
    let categoryIcon: String
    let categoryId: String
    let durationText: String
    let destinationId: String
    let isFree: Bool
    let hasFreeCancel: Bool
    let meetingPoint: String
    let includes: [String]
    let priceValue: Double
}
