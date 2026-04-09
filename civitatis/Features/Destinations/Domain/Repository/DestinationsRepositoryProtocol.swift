import Foundation

protocol DestinationsRepositoryProtocol: Sendable {
    func fetchAllDestinations() -> [Destination]
    func fetchActivities(for destinationId: String) -> [Activity]
}
