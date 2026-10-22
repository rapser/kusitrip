import Foundation

struct GetDestinationsUseCase: Sendable {
    private let repository: any DestinationsRepositoryProtocol

    init() {
        self.repository = DestinationsRepositoryImpl()
    }

    init(repository: any DestinationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [Destination] {
        repository.fetchAllDestinations()
    }

    func executeActivities(for destinationId: String) -> [Activity] {
        repository.fetchActivities(for: destinationId)
    }
}
