import Foundation

@MainActor
@Observable
final class SearchViewModel {
    var searchText: String = "" { didSet { scheduleSearch() } }
    var resultActivities: [ActivityUI] = []
    var resultDestinations: [DestinationUI] = []
    var featuredDestinations: [DestinationUI] = []
    var isSearching: Bool = false
    var isLoadingSuggestions: Bool = true
    var hasSearched: Bool = false
    var errorMessage: String?

    private let useCase: SearchUseCase
    private let destinationsUseCase: GetDestinationsUseCase
    private var searchTask: Task<Void, Never>?

    init() {
        self.useCase = SearchUseCase()
        self.destinationsUseCase = GetDestinationsUseCase()
    }

    init(useCase: SearchUseCase, destinationsUseCase: GetDestinationsUseCase) {
        self.useCase = useCase
        self.destinationsUseCase = destinationsUseCase
    }

    func loadSuggestions() async {
        guard featuredDestinations.isEmpty else { return }
        defer { isLoadingSuggestions = false }
        let destinations = (try? await destinationsUseCase.execute()) ?? []
        featuredDestinations = destinations.prefix(4).map { DestinationMapper.toUI(entity: $0) }
    }

    private func scheduleSearch() {
        searchTask?.cancel()
        guard !searchText.isEmpty else {
            resultActivities = []
            resultDestinations = []
            hasSearched = false
            errorMessage = nil
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
        errorMessage = nil
        defer { isSearching = false }
        do {
            let results = try await useCase.execute(query: searchText)
            guard !Task.isCancelled else { return }
            resultActivities   = results.activities.map { ActivityMapper.toUI(entity: $0) }
            resultDestinations = results.destinations.map { DestinationMapper.toUI(entity: $0) }
            hasSearched = true
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
            hasSearched = true
        }
    }
}
