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
                // Country filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.countries, id: \.self) { country in
                            Button(country) {
                                viewModel.selectedCountry = country
                            }
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedCountry == country ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedCountry == country ? Color.kusiPrimary : Color.kusiSurface)
                            .foregroundStyle(Color.kusiTextPrimary)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(viewModel.selectedCountry == country ? Color.kusiPrimary : Color.kusiBorder))
                        }
                        // The country chips come from the catalog: placeholders until it loads.
                        if viewModel.isLoading {
                            HStack(spacing: 10) {
                                ForEach([72, 88, 64], id: \.self) { width in
                                    SkeletonBlock(width: CGFloat(width), height: 36, cornerRadius: 18)
                                }
                            }
                            .kusiShimmer()
                            .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }

                Group {
                    if viewModel.isLoading {
                        loadingSkeleton
                            .transition(.opacity)
                    } else if let error = viewModel.errorMessage {
                        ErrorStateView(message: error) { await viewModel.load() }
                            .transition(.opacity)
                    } else if viewModel.filteredDestinations.isEmpty {
                        emptyState
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            destinationCount
                            destinationsGrid
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.35), value: viewModel.isLoading)
            }
        }
    }

    private var loadingSkeleton: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBlock(width: 140, height: 12, cornerRadius: 4)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(0..<6, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.kusiBorder.opacity(0.55))
                        .aspectRatio(4 / 5, contentMode: .fit)
                }
            }
            .padding(.horizontal, 16)
        }
        .kusiShimmer()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando destinos")
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
            Text("Prueba con otro término de búsqueda o país.")
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
