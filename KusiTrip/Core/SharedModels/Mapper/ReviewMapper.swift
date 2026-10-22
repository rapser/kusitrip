import Foundation

enum ReviewMapper {

    static func toDomain(dto: ReviewDTO) -> Review {
        Review(
            id: dto.id,
            activityId: dto.activityId,
            authorName: dto.authorName,
            city: dto.city,
            rating: dto.rating,
            comment: dto.comment,
            date: dto.date,
            travelType: dto.travelType
        )
    }

    static func toUI(entity: Review) -> ReviewUI {
        let initials = entity.authorName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
        let (icon, label) = travelInfo(entity.travelType)
        return ReviewUI(
            id: entity.id,
            activityId: entity.activityId,
            authorName: entity.authorName,
            initials: initials,
            city: entity.city,
            ratingText: String(format: "%.1f", entity.rating),
            comment: entity.comment,
            date: entity.date,
            travelTypeLabel: label,
            travelTypeIcon: icon
        )
    }

    private static func travelInfo(_ type: String) -> (String, String) {
        switch type {
        case "pareja":  return ("heart",                         "Viajó en pareja")
        case "familia": return ("figure.2.and.child.holdinghands","Viajó en familia")
        case "amigos":  return ("figure.2",                      "Viajó con amigos")
        case "solo":    return ("figure.walk",                   "Viajó solo")
        default:        return ("person",                        "Viajó")
        }
    }
}
