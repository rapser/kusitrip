import Foundation

struct SearchUseCase: Sendable {
    private let repository: any SearchRepositoryProtocol

    init() {
        self.repository = SearchRepositoryImpl()
    }

    init(repository: any SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> SearchResult {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return .empty }
        return try await repository.search(query: trimmed)
    }
}
