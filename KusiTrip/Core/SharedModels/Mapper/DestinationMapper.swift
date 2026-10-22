import Foundation

enum DestinationMapper {

    static func toDomain(dto: DestinationDTO) -> Destination {
        Destination(
            id: dto.id,
            name: dto.name,
            country: dto.country,
            continent: dto.continent,
            imageURL: dto.imageUrl,
            activityCount: dto.activityCount,
            travelerCount: dto.travelerCount,
            reviewCount: dto.reviewCount,
            rating: dto.rating,
            description: dto.description
        )
    }

    static func toUI(entity: Destination) -> DestinationUI {
        DestinationUI(
            id: entity.id,
            name: entity.name,
            country: entity.country,
            continent: entity.continent,
            imageURL: entity.imageURL,
            activityCountText: "\(entity.activityCount) actividades",
            travelerCountText: format(entity.travelerCount) + " viajeros",
            reviewCountText: format(entity.reviewCount) + " opiniones",
            ratingText: "\(String(format: "%.1f", entity.rating)) / 10",
            description: entity.description
        )
    }

    private static func format(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
}
