import Foundation

struct HomeData: Sendable {
    let destinations: [Destination]
    let featuredActivities: [Activity]
    let categories: [Category]
}
