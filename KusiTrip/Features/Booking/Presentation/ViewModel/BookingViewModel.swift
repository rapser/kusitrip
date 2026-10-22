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

    // Activity info (loaded from the API)
    var activityId: String = ""
    var activityTitle: String = ""
    var pricePerPerson: Double = 0.0
    var currency: String = "USD"
    var hasFreeCancel: Bool = false

    var totalPrice: Double { pricePerPerson * Double(numberOfPeople) }
    var formattedPricePerPerson: String { pricePerPerson.kusiPrice(currency: currency) }
    var formattedTotal: String { totalPrice == 0 ? "¡Gratis!" : totalPrice.kusiPrice(currency: currency) }

    var minimumDate: Date { Date() }
    var maximumDate: Date { Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date() }

    private let createBookingUseCase: CreateBookingUseCase
    private let activityUseCase: GetActivityDetailUseCase

    init() {
        self.createBookingUseCase = CreateBookingUseCase()
        self.activityUseCase = GetActivityDetailUseCase()
    }

    init(createBookingUseCase: CreateBookingUseCase, activityUseCase: GetActivityDetailUseCase) {
        self.createBookingUseCase = createBookingUseCase
        self.activityUseCase = activityUseCase
    }

    func loadActivity(id: String) async {
        guard activityId != id else { return }
        activityId = id
        do {
            let activity = try await activityUseCase.execute(id: id)
            activityTitle = activity.title
            pricePerPerson = activity.price
            currency = activity.currency
            hasFreeCancel = activity.cancellationDays > 0
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func confirm() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let request = BookingRequest(
                activityId: activityId,
                date: selectedDate,
                numberOfPeople: numberOfPeople
            )
            let result = try await createBookingUseCase.execute(request: request)
            confirmation = BookingMapper.toUI(confirmation: result)
            await EventBus.shared.send(
                .bookingConfirmed(bookingId: result.bookingId, activityTitle: result.activityTitle)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
