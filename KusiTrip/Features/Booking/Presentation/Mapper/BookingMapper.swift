import Foundation

enum BookingMapper {
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
            formattedDate: dateFormatter.string(from: confirmation.date),
            formattedTime: timeFormatter.string(from: confirmation.date),
            numberOfPeopleText: "\(confirmation.numberOfPeople) persona\(confirmation.numberOfPeople > 1 ? "s" : "")",
            formattedTotal: "S/ \(String(format: "%.2f", confirmation.totalPrice))",
            confirmedAt: confirmedFormatter.string(from: confirmation.confirmedAt)
        )
    }
}
