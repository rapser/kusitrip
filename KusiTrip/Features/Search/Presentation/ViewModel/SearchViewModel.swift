import Foundation

@MainActor
@Observable
final class SearchViewModel {
    var searchText: String = "" { didSet { scheduleSearch() } }
    var resultActivities: [ActivityUI] = []
    var resultDestinations: [DestinationUI] = []
    var isSearching: Bool = false
    var hasSearched: Bool = false

    private let useCase: SearchUseCase
    private var searchTask: Task<Void, Never>?

    init() {
        self.useCase = SearchUseCase()
    }

    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    private func scheduleSearch() {
        searchTask?.cancel()
        guard !searchText.isEmpty else {
            resultActivities = []
            resultDestinations = []
            hasSearched = false
            return
        }
        searchTask = Task {
            // Debounce: 400ms
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await performSearch()
        }
    }

    private func performSearch() async {
        isSearching = true
        defer { isSearching = false }
        hasSearched = true
        let results = useCase.execute(query: searchText)
        resultActivities   = results.activities.map { ActivityMapper.toUI(entity: $0) }
        resultDestinations = results.destinations.map { DestinationMapper.toUI(entity: $0) }
    }
}
