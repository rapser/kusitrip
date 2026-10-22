import Foundation

struct GetDestinationsUseCase: Sendable {
    private let repository: any DestinationsRepositoryProtocol

    init() {
        self.repository = DestinationsRepositoryImpl()
    }

    init(repository: any DestinationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Destination] {
        try await repository.fetchAllDestinations()
    }

    func executeDestination(id: String) async throws -> Destination {
        try await repository.fetchDestination(id: id)
    }

    func executeActivities(for destinationId: String) async throws -> [Activity] {
        try await repository.fetchActivities(for: destinationId)
    }
}
