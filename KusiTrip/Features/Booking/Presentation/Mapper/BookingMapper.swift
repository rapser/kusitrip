import Foundation

enum BookingMapper {
    static func toDomain(dto: BookingDTO) -> BookingConfirmation {
        BookingConfirmation(
            id: dto.id,
            bookingId: dto.bookingNumber,
            activityId: dto.activityId,
            activityTitle: dto.activityTitle,
            activityImageURL: dto.activityImageUrl,
            date: ISO8601DateFormatter.kusiAPI.date(from: dto.date) ?? Date(),
            numberOfPeople: dto.numberOfPeople,
            totalPrice: dto.totalPrice,
            currency: dto.currency,
            status: BookingStatus(rawValue: dto.status) ?? .confirmed,
            confirmedAt: ISO8601DateFormatter.kusiAPI.date(from: dto.confirmedAt) ?? Date()
        )
    }

    static func toUI(confirmation: BookingConfirmation) -> BookingConfirmationUI {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateStyle = .long

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "es_ES")

        let confirmedFormatter = DateFormatter()
        confirmedFormatter.locale = Locale(identifier: "es_ES")
        confirmedFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        return BookingConfirmationUI(
            id: confirmation.id,
            bookingId: confirmation.bookingId,
            activityTitle: confirmation.activityTitle,
            activityImageURL: confirmation.activityImageURL,
            formattedDate: dateFormatter.string(from: confirmation.date),
            formattedTime: timeFormatter.string(from: confirmation.date),
            numberOfPeopleText: "\(confirmation.numberOfPeople) persona\(confirmation.numberOfPeople > 1 ? "s" : "")",
            formattedTotal: confirmation.totalPrice == 0
                ? "¡Gratis!"
                : confirmation.totalPrice.kusiPrice(currency: confirmation.currency),
            confirmedAt: confirmedFormatter.string(from: confirmation.confirmedAt),
            isCancelled: confirmation.status == .cancelled,
            isUpcoming: confirmation.date > Date()
        )
    }
}
