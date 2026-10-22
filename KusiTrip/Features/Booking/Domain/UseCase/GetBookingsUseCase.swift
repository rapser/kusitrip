import Foundation

struct GetBookingsUseCase: Sendable {
    private let repository: any BookingRepositoryProtocol

    init() {
        self.repository = BookingRepositoryImpl()
    }

    init(repository: any BookingRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [BookingConfirmation] {
        try await repository.fetchBookings()
    }

    func cancel(id: String) async throws -> BookingConfirmation {
        try await repository.cancelBooking(id: id)
    }
}
