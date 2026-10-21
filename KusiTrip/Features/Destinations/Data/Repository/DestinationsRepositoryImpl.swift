import Foundation

struct DestinationsRepositoryImpl: DestinationsRepositoryProtocol {

    func fetchAllDestinations() -> [Destination] {
        SampleDestinations.all.map { DestinationMapper.toDomain(dto: $0) }
    }

    func fetchActivities(for destinationId: String) -> [Activity] {
        SampleActivities.all
            .filter { $0.destinationId == destinationId }
            .map { ActivityMapper.toDomain(dto: $0) }
    }
}
