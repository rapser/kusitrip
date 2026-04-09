import Foundation

struct SearchUseCase: Sendable {
    private let repository: any SearchRepositoryProtocol

    init() {
        self.repository = SearchRepositoryImpl()
    }

    init(repository: any SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) -> (activities: [Activity], destinations: [Destination]) {
        guard query.count >= 2 else { return ([], []) }
        return repository.search(query: query)
    }
}
