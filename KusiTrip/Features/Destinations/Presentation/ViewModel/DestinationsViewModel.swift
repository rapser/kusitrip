import Foundation

@MainActor
@Observable
final class DestinationsViewModel {
    var allDestinations: [DestinationUI] = []
    var filteredDestinations: [DestinationUI] = []
    var searchText: String = "" { didSet { applyFilters() } }
    var selectedContinent: String = "Todos" { didSet { applyFilters() } }
    var isLoading: Bool = false

    let continents = ["Todos", "Europa", "América", "Asia", "África", "Oceanía"]

    private let useCase: GetDestinationsUseCase

    init() {
        self.useCase = GetDestinationsUseCase()
    }

    init(useCase: GetDestinationsUseCase) {
        self.useCase = useCase
    }

    func load() async {
        guard allDestinations.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        allDestinations = useCase.execute().map { DestinationMapper.toUI(entity: $0) }
        applyFilters()
    }

    func applyFilters() {
        var result = allDestinations
        if selectedContinent != "Todos" {
            result = result.filter { $0.continent == selectedContinent }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.country.localizedCaseInsensitiveContains(searchText)
            }
        }
        filteredDestinations = result
    }
}
