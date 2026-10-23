import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        VStack(spacing: 0) {
            KusiScreenHeader(title: "Buscar") {
                SearchFieldView(prompt: "Destinos, actividades, tours...", text: $viewModel.searchText)
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if viewModel.searchText.isEmpty {
                        suggestionsSection
                    } else if viewModel.isSearching || !viewModel.hasSearched {
                        // Also while the 400 ms debounce waits to send the query.
                        searchingSkeleton
                            .transition(.opacity)
                    } else {
                        resultsSection
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.isSearching)
            }
        }
        .background(Color.kusiBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.kusiPrimary, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .task { await viewModel.loadSuggestions() }
    }

    // MARK: - Suggestions (empty state)
    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Búsquedas populares")
                .font(.headline)
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 16)
                .padding(.top, 16)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 10
            ) {
                ForEach(popularSuggestions, id: \.self) { suggestion in
                    Button {
                        viewModel.searchText = suggestion
                    } label: {
                        Text(suggestion)
                            .font(.subheadline)
                            .foregroundStyle(Color.kusiTextPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.kusiSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.kusiBorder))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)

            Text("Destinos destacados")
                .font(.headline)
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.featuredDestinations) { dest in
                        NavigationLink(value: AppRoute.destinationDetail(id: dest.id)) {
                            DestinationCard(destination: dest)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
            .overlay(alignment: .leading) {
                if viewModel.isLoadingSuggestions {
                    SkeletonCarousel(spacing: 12) {
                        ForEach(0..<3, id: \.self) { _ in
                            SkeletonBlock(width: 160, height: 200, cornerRadius: 14)
                        }
                    }
                    .frame(height: 200)
                    .kusiShimmer()
                    .transition(.opacity)
                }
            }
            .frame(minHeight: viewModel.isLoadingSuggestions ? 200 : nil)
            .animation(.easeInOut(duration: 0.35), value: viewModel.isLoadingSuggestions)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Searching
    /// Result count line and rows with the shape of `searchActivityRow`.
    private var searchingSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonBlock(width: 200, height: 12, cornerRadius: 4)
                .padding(.vertical, 4)
            ForEach(0..<5, id: \.self) { _ in
                HStack(spacing: 12) {
                    SkeletonBlock(width: 80, height: 70, cornerRadius: 8)
                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonBlock(height: 13, cornerRadius: 5)
                        SkeletonBlock(width: 120, height: 10, cornerRadius: 4)
                        SkeletonBlock(width: 80, height: 13, cornerRadius: 5)
                    }
                }
                .padding(12)
                .kusiCard()
            }
        }
        .padding(16)
        .kusiShimmer()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Buscando \(viewModel.searchText)")
    }

    // MARK: - Results
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            let total = viewModel.resultActivities.count + viewModel.resultDestinations.count
            if let error = viewModel.errorMessage {
                ErrorStateView(message: error)
            }
            Text(total == 0 ? "Sin resultados para \"\(viewModel.searchText)\"" : "\(total) resultados para \"\(viewModel.searchText)\"")
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
                .padding(16)

            if !viewModel.resultDestinations.isEmpty {
                Text("Destinos")
                    .font(.headline)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.resultDestinations) { dest in
                            NavigationLink(value: AppRoute.destinationDetail(id: dest.id)) {
                                DestinationCard(destination: dest)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 16)
            }

            if !viewModel.resultActivities.isEmpty {
                Text("Actividades")
                    .font(.headline)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                LazyVStack(spacing: 12) {
                    ForEach(viewModel.resultActivities) { activity in
                        NavigationLink(value: AppRoute.activityDetail(id: activity.id)) {
                            searchActivityRow(activity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }

            if total == 0 {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.kusiBorder)
                    Text("Prueba con otros términos como\n\"Roma\", \"free tour\" o \"Barcelona\"")
                        .font(.subheadline)
                        .foregroundStyle(Color.kusiTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
            }
        }
    }

    private func searchActivityRow(_ activity: ActivityUI) -> some View {
        HStack(spacing: 12) {
            RemoteImage(url: activity.primaryImageURL)
                .frame(width: 80, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .lineLimit(2)
                HStack(spacing: 4) {
                    StarRatingView(rating: activity.ratingValue)
                    Text(activity.ratingText)
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("·")
                        .foregroundStyle(Color.kusiBorder)
                    Text(activity.durationText)
                        .font(.caption)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
                Text(activity.isFree ? "¡Gratis!" : "desde \(activity.formattedPrice)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color.kusiBorder)
        }
        .padding(12)
        .kusiCard()
    }

    private var popularSuggestions: [String] {
        ["Machu Picchu", "Cusco", "Free tour", "Montaña Arcoíris", "Islas Ballestas", "Colca", "Tango", "Cristo Redentor"]
    }
}
