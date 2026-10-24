import Foundation

@MainActor
@Observable
final class DestinationsViewModel {
    static let allCountries = "Todos"

    var allDestinations: [DestinationUI] = []
    var filteredDestinations: [DestinationUI] = []
    var searchText: String = "" { didSet { applyFilters() } }
    var selectedCountry: String = DestinationsViewModel.allCountries { didSet { applyFilters() } }
    // True from the start, so the first frame already shows the skeleton.
    var isLoading: Bool = true
    var errorMessage: String?

    /// Country chips built from the catalog, in the order the API returns destinations.
    var countries: [String] {
        var seen = Set<String>()
        return [Self.allCountries] + allDestinations.compactMap { seen.insert($0.country).inserted ? $0.country : nil }
    }

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
        errorMessage = nil
        defer { isLoading = false }
        do {
            allDestinations = try await useCase.execute().map { DestinationMapper.toUI(entity: $0) }
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func applyFilters() {
        var result = allDestinations
        if selectedCountry != Self.allCountries {
            result = result.filter { $0.country == selectedCountry }
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
