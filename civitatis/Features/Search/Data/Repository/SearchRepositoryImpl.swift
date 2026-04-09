import Foundation

struct SearchRepositoryImpl: SearchRepositoryProtocol {

    func search(query: String) -> (activities: [Activity], destinations: [Destination]) {
        let q = query.lowercased()
        let activities = SampleActivities.all
            .filter {
                $0.title.lowercased().contains(q) ||
                $0.descriptionText.lowercased().contains(q)
            }
            .map { ActivityMapper.toDomain(dto: $0) }
        let destinations = SampleDestinations.all
            .filter {
                $0.name.lowercased().contains(q) ||
                $0.country.lowercased().contains(q) ||
                $0.description.lowercased().contains(q)
            }
            .map { DestinationMapper.toDomain(dto: $0) }
        return (activities, destinations)
    }
}
