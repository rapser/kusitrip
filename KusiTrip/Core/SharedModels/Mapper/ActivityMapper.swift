import Foundation

enum ActivityMapper {

    static func toDomain(dto: ActivityDTO) -> Activity {
        Activity(
            id: dto.id,
            title: dto.title,
            summary: dto.summary,
            description: dto.description,
            price: dto.price,
            originalPrice: dto.originalPrice,
            currency: dto.currency,
            rating: dto.rating,
            reviewCount: dto.reviewCount,
            travelerCount: dto.travelerCount,
            category: CategoryMapper.toDomain(dto: dto.category),
            destinationId: dto.destinationId,
            imageURLs: dto.imageUrls,
            durationMinutes: dto.durationMinutes,
            language: dto.language,
            cancellationDays: dto.freeCancellationDays,
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
            let days = entity.durationMinutes / (24 * 60)
            if days >= 2 { return "\(days) días" }
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
            formattedPrice: entity.isFree ? "¡Gratis!" : entity.price.kusiPrice(currency: entity.currency),
            formattedOriginalPrice: entity.originalPrice.map { $0.kusiPrice(currency: entity.currency) },
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
            priceValue: entity.price,
            currency: entity.currency
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
