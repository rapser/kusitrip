import SwiftUI

struct DestinationsView: View {
    @State private var viewModel = DestinationsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            KusiScreenHeader(title: "Destinos") {
                SearchFieldView(prompt: "Buscar destinos o países", text: $viewModel.searchText)
            }
            content
        }
        .background(Color.kusiBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.kusiPrimary, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .task { await viewModel.load() }
    }

    private var content: some View {
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
                            .foregroundStyle(Color.kusiTextPrimary)
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
                        .tint(Color.kusiTextPrimary)
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

private struct DestinationGridCard: View {
    let destination: DestinationUI

    var body: some View {
        RemoteImage(url: destination.imageURL)
            .aspectRatio(4 / 5, contentMode: .fit)
            .overlay {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.75)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .overlay(alignment: .topTrailing) {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                    Text(destination.ratingText)
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.kusiPrimary)
                .clipShape(Capsule())
                .padding(8)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(destination.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(destination.country)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                    Text(destination.activityCountText)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.75))
                        .lineLimit(1)
                }
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .contentShape(RoundedRectangle(cornerRadius: 14))
    }
}
