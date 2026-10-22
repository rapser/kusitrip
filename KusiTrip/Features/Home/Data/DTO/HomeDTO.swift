import Foundation

nonisolated struct HomeDTO: Decodable, Sendable {
    let categories: [CategoryDTO]
    let destinations: [DestinationDTO]
    let featuredActivities: [ActivityDTO]
}
