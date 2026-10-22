import Foundation

struct HomeRepositoryImpl: HomeRepositoryProtocol {

    func fetchFeaturedActivities() -> [Activity] {
        SampleActivities.all.prefix(6).map { ActivityMapper.toDomain(dto: $0) }
    }

    func fetchDestinations() -> [Destination] {
        SampleDestinations.all.map { DestinationMapper.toDomain(dto: $0) }
    }

    func fetchCategories() -> [Category] {
        CategoryMapper.allCategories
    }
}
