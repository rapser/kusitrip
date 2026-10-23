import Foundation

@MainActor
@Observable
final class MyBookingsViewModel {
    var bookings: [BookingConfirmationUI] = []
    // True from the start, so the first frame already shows the skeleton.
    var isLoading: Bool = true
    var errorMessage: String?

    private let useCase: GetBookingsUseCase

    init() {
        self.useCase = GetBookingsUseCase()
    }

    init(useCase: GetBookingsUseCase) {
        self.useCase = useCase
    }

    func load() async {
        isLoading = bookings.isEmpty
        errorMessage = nil
        defer { isLoading = false }
        do {
            bookings = try await useCase.execute().map { BookingMapper.toUI(confirmation: $0) }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func cancel(_ booking: BookingConfirmationUI) async {
        do {
            let updated = BookingMapper.toUI(confirmation: try await useCase.cancel(id: booking.id))
            if let index = bookings.firstIndex(where: { $0.id == updated.id }) {
                bookings[index] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
