import Foundation

protocol SearchRepositoryProtocol: Sendable {
    func search(query: String) async throws -> SearchResult
}
