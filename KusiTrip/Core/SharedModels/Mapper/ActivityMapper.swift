import Foundation

enum ActivityMapper {

    static let allCategories: [Category] = [
        .all, .guided, .excursions, .tickets, .gastronomy, .transport, .boat, .free
    ]

    static func toDomain(dto: ActivityDTO) -> Activity {
        let category = allCategories.first(where: { $0.id == dto.categoryId }) ?? .all
        return Activity(
            id: dto.id,
            title: dto.title,
            description: dto.descriptionText,
            price: dto.price,
            originalPrice: dto.originalPrice,
            rating: dto.rating,
            reviewCount: dto.reviewCount,
            travelerCount: dto.travelerCount,
            category: category,
            destinationId: dto.destinationId,
            imageURLs: dto.imageURLs,
            durationMinutes: dto.durationMinutes,
            language: dto.language,
            cancellationDays: dto.cancellationDays,
            isFree: dto.isFree,
            meetingPoint: dto.meetingPoint,
            includes: dto.includes
        )
    }

    static func toUI(entity: Activity) -> ActivityUI {
        let discountPct: Int? = {
            guard let orig = entity.originalPrice, orig > entity.price else { return nil }
            return Int(((orig - entity.price) / orig) * 100)
        }()
        let durationText: String = {
            let h = entity.durationMinutes / 60
            let m = entity.durationMinutes % 60
            if h == 0 { return "\(m) min" }
            if m == 0 { return "\(h)h" }
            return "\(h)h \(m)m"
        }()
        return ActivityUI(
            id: entity.id,
            title: entity.title,
            fullDescription: entity.description,
            formattedPrice: entity.isFree ? "¡Gratis!" : "S/ \(String(format: "%.2f", entity.price))",
            formattedOriginalPrice: entity.originalPrice.map { "S/ \(String(format: "%.2f", $0))" },
            discountPercentage: discountPct,
            ratingValue: entity.rating,
            ratingText: String(format: "%.1f", entity.rating),
            reviewCountText: "\(entity.reviewCount.kusiFormatted) opiniones",
            travelerCountText: "\(entity.travelerCount.kusiFormatted) viajeros",
            primaryImageURL: entity.imageURLs.first ?? "",
            imageURLs: entity.imageURLs,
            categoryLabel: entity.category.name,
            categoryIcon: entity.category.icon,
            categoryId: entity.category.id,
            durationText: durationText,
            destinationId: entity.destinationId,
            isFree: entity.isFree,
            hasFreeCancel: entity.cancellationDays > 0,
            meetingPoint: entity.meetingPoint,
            includes: entity.includes,
            priceValue: entity.price
        )
    }
}

private extension Int {
    var kusiFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
