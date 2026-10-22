import Foundation

struct CreateBookingUseCase: Sendable {

    func execute(request: BookingRequest) async throws -> BookingConfirmation {
        // Simulate processing
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let bookingId = "KUSI-\(Int.random(in: 100000...999999))"
        return BookingConfirmation(
            id: UUID().uuidString,
            bookingId: bookingId,
            activityTitle: request.activityTitle,
            date: request.date,
            numberOfPeople: request.numberOfPeople,
            totalPrice: request.totalPrice,
            confirmedAt: Date()
        )
    }
}
