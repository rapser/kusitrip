import Foundation

protocol HomeRepositoryProtocol: Sendable {
    func fetchFeaturedActivities() -> [Activity]
    func fetchDestinations() -> [Destination]
    func fetchCategories() -> [Category]
}
