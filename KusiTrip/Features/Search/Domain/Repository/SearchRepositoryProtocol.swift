import Foundation

protocol SearchRepositoryProtocol: Sendable {
    func search(query: String) -> (activities: [Activity], destinations: [Destination])
}
