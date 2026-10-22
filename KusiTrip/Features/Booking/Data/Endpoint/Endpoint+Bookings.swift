import Foundation

extension Endpoint {
    nonisolated static func createBooking(_ body: CreateBookingRequestDTO) -> Endpoint {
        Endpoint(path: "bookings", method: .post, body: body, requiresAuth: true)
    }

    nonisolated static let bookings = Endpoint(path: "bookings", requiresAuth: true)

    nonisolated static func cancelBooking(id: String) -> Endpoint {
        Endpoint(path: "bookings/\(id)/cancel", method: .patch, requiresAuth: true)
    }
}
