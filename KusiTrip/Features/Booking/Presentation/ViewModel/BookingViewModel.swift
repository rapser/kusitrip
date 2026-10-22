import Foundation

@MainActor
@Observable
final class BookingViewModel {
    // Input
    var selectedDate: Date = Date().addingTimeInterval(86400)
    var numberOfPeople: Int = 2

    // State
    var isLoading: Bool = false
    var confirmation: BookingConfirmationUI?
    var errorMessage: String?

    // Activity info (loaded externally)
    var activityId: String = ""
    var activityTitle: String = ""
    var pricePerPerson: Double = 0.0

    var totalPrice: Double { pricePerPerson * Double(numberOfPeople) }
    var formattedTotal: String { "S/ \(String(format: "%.2f", totalPrice))" }

    var minimumDate: Date { Date() }
    var maximumDate: Date { Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date() }

    private let useCase = CreateBookingUseCase()

    func loadActivity(id: String) {
        activityId = id
        guard let dto = SampleActivities.all.first(where: { $0.id == id }) else { return }
        activityTitle = dto.title
        pricePerPerson = dto.price
    }

    func confirm() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let request = BookingRequest(
                activityId: activityId,
                activityTitle: activityTitle,
                pricePerPerson: pricePerPerson,
                date: selectedDate,
                numberOfPeople: numberOfPeople
            )
            let result = try await useCase.execute(request: request)
            confirmation = BookingMapper.toUI(confirmation: result)
            await EventBus.shared.send(
                .bookingConfirmed(bookingId: result.bookingId, activityTitle: activityTitle)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
