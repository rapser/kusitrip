import Foundation

struct CreateBookingUseCase: Sendable {
    private let repository: any BookingRepositoryProtocol

    init() {
        self.repository = BookingRepositoryImpl()
    }

    init(repository: any BookingRepositoryProtocol) {
        self.repository = repository
    }

    func execute(request: BookingRequest) async throws -> BookingConfirmation {
        try await repository.createBooking(request)
    }
}
