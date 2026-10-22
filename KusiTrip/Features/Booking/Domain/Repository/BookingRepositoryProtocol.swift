import Foundation

protocol BookingRepositoryProtocol: Sendable {
    func createBooking(_ request: BookingRequest) async throws -> BookingConfirmation
    func fetchBookings() async throws -> [BookingConfirmation]
    func cancelBooking(id: String) async throws -> BookingConfirmation
}
