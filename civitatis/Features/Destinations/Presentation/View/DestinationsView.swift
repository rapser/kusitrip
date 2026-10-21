import SwiftUI

struct DestinationsView: View {
    @State private var viewModel = DestinationsViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Continent filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.continents, id: \.self) { continent in
                            Button(continent) {
                                viewModel.selectedContinent = continent
                            }
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedContinent == continent ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedContinent == continent ? Color.kusiPrimary : Color.kusiSurface)
                            .foregroundStyle(viewModel.selectedContinent == continent ? .white : Color.kusiTextPrimary)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(viewModel.selectedContinent == continent ? Color.kusiPrimary : Color.kusiBorder))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.4)
                        .tint(Color.kusiPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else if viewModel.filteredDestinations.isEmpty {
                    emptyState
                } else {
                    destinationCount
                    destinationsGrid
                }
            }
        }
        .background(Color.kusiBackground)
        .navigationTitle("Destinos")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText, prompt: "Buscar destinos o países")
        .task { await viewModel.load() }
    }

    private var destinationCount: some View {
        Text("\(viewModel.filteredDestinations.count) destinos disponibles")
            .font(.caption)
            .foregroundStyle(Color.kusiTextSecondary)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
    }

    private var destinationsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
            spacing: 12
        ) {
            ForEach(viewModel.filteredDestinations) { destination in
                NavigationLink(value: AppRoute.destinationDetail(id: destination.id)) {
                    DestinationGridCard(destination: destination)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(Color.kusiBorder)
            Text("No se encontraron destinos")
                .font(.headline)
                .foregroundStyle(Color.kusiTextSecondary)
            Text("Prueba con otro término de búsqueda o continente.")
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

// Full-width grid card
private struct DestinationGridCard: View {
    let destination: DestinationUI

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: destination.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    Color.kusiBorder.overlay(ProgressView().tint(Color.kusiPrimary))
                }
            }
            .frame(height: 180)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.78)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(destination.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text(destination.activityCountText)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
                Text(destination.travelerCountText)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.70))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
