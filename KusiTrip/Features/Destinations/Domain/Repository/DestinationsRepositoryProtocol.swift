import Foundation

protocol DestinationsRepositoryProtocol: Sendable {
    func fetchAllDestinations() async throws -> [Destination]
    func fetchDestination(id: String) async throws -> Destination
    func fetchActivities(for destinationId: String) async throws -> [Activity]
}
