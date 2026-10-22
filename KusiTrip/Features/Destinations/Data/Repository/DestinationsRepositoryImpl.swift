import Foundation

struct DestinationsRepositoryImpl: DestinationsRepositoryProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = AppDependencies.shared.apiClient) {
        self.apiClient = apiClient
    }

    func fetchAllDestinations() async throws -> [Destination] {
        let dtos = try await apiClient.send(.destinations, as: [DestinationDTO].self)
        return dtos.map { DestinationMapper.toDomain(dto: $0) }
    }

    func fetchDestination(id: String) async throws -> Destination {
        let dto = try await apiClient.send(.destination(id: id), as: DestinationDTO.self)
        return DestinationMapper.toDomain(dto: dto)
    }

    func fetchActivities(for destinationId: String) async throws -> [Activity] {
        let dtos = try await apiClient.send(.destinationActivities(id: destinationId), as: [ActivityDTO].self)
        return dtos.map { ActivityMapper.toDomain(dto: $0) }
    }
}
