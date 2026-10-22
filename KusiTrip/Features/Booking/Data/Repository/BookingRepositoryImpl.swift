import Foundation

struct BookingRepositoryImpl: BookingRepositoryProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = AppDependencies.shared.apiClient) {
        self.apiClient = apiClient
    }

    func createBooking(_ request: BookingRequest) async throws -> BookingConfirmation {
        let body = CreateBookingRequestDTO(
            activityId: request.activityId,
            date: ISO8601DateFormatter.kusiAPI.string(from: request.date),
            numberOfPeople: request.numberOfPeople
        )
        let dto = try await apiClient.send(.createBooking(body), as: BookingDTO.self)
        return BookingMapper.toDomain(dto: dto)
    }

    func fetchBookings() async throws -> [BookingConfirmation] {
        let dtos = try await apiClient.send(.bookings, as: [BookingDTO].self)
        return dtos.map { BookingMapper.toDomain(dto: $0) }
    }

    func cancelBooking(id: String) async throws -> BookingConfirmation {
        let dto = try await apiClient.send(.cancelBooking(id: id), as: BookingDTO.self)
        return BookingMapper.toDomain(dto: dto)
    }
}
