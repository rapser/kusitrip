import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Query private var favorites: [FavoriteModel]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                heroBanner

                if viewModel.isLoading {
                    loadingPlaceholder
                } else if let error = viewModel.errorMessage, viewModel.destinations.isEmpty {
                    ErrorStateView(message: error) { await viewModel.load() }
                } else {
                    destinationsSection
                    categoriesSection
                    featuredSection
                    appPromoSection
                }
            }
            // Must not extend into the safe area, or it covers the yellow status bar area
            .background(Color.kusiBackground, ignoresSafeAreaEdges: [])
            .scrollBounceDisabled()
        }
        // Yellow behind the status bar, matching the headers of the other tabs
        .background(Color.kusiPrimary, ignoresSafeAreaEdges: .top)
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .navigationBarHidden(true)
    }

    // MARK: - Hero banner
    private var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImage(url: "https://f.civitatis.com/peru/cusco/galeria/machu-picchu.jpg")
                .frame(height: 260)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.black.opacity(0.65), .black.opacity(0.20), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(height: 260)

            VStack(alignment: .leading, spacing: 6) {
                Text("LLENA TU VIAJE")
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(.white.opacity(0.85))
                    .kerning(2.5)
                Text("Visitas guiadas y excursiones\nen español")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                NavigationLink(value: AppRoute.destinationDetail(id: "")) {
                    Label("Descubrir destinos", systemImage: "arrow.right")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.kusiTextPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.kusiPrimary)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(height: 260)
    }

    // MARK: - Destinations
    private var destinationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Principales destinos")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
                Spacer()
                NavigationLink(value: AppRoute.destinationDetail(id: "")) {
                    Text("Ver todos")
                        .font(.subheadline)
                        .foregroundStyle(Color.kusiTextPrimary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.destinations) { destination in
                        NavigationLink(value: AppRoute.destinationDetail(id: destination.id)) {
                            DestinationCard(destination: destination)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Categories
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿Qué quieres hacer?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 16)
                .padding(.top, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(viewModel.categories) { category in
                        CategoryChipView(category: category, isSelected: false) {}
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Featured activities
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Actividades destacadas")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 16)
                .padding(.top, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(viewModel.featuredActivities) { activity in
                        NavigationLink(value: AppRoute.activityDetail(id: activity.id)) {
                            ActivityCard(
                                activity: activity,
                                isFavorited: favorites.contains(where: { $0.activityId == activity.id }),
                                onFavorite: { _ in
                                    let isFavorite = modelContext.toggleFavorite(activity)
                                    Task { await EventBus.shared.send(.favoriteToggled(activityId: activity.id, isFavorite: isFavorite)) }
                                }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
    }

    // MARK: - App promo
    private var appPromoSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Cómo nos valoran")
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
                HStack(spacing: 6) {
                    Text("9,1 / 10")
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundStyle(Color.kusiTextPrimary)
                    StarRatingView(rating: 9.1)
                }
                Text("+5.000.000 opiniones")
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
            }
            Spacer()
            Image(systemName: "globe.europe.africa.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.kusiTextPrimary.opacity(0.15))
        }
        .padding(20)
        .background(Color.kusiSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(16)
        .padding(.bottom, 8)
    }

    // MARK: - Loading placeholder
    private var loadingPlaceholder: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.4)
                .tint(Color.kusiTextPrimary)
            Text("Cargando destinos...")
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
