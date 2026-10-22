import Foundation

nonisolated struct SearchDTO: Decodable, Sendable {
    let activities: [ActivityDTO]
    let destinations: [DestinationDTO]
}
