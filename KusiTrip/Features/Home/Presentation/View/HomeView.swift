import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Query private var favorites: [FavoriteModel]
    @Environment(\.modelContext) private var modelContext

    /// 0 with the photo fully shown, 1 once it has scrolled under the
    /// navigation bar and turned into it.
    @State private var collapseProgress: CGFloat = 0

    private static let heroHeight: CGFloat = 300

    var body: some View {
        GeometryReader { proxy in
            // Bottom edge of the navigation bar, which the photo collapses into.
            let barBottom = proxy.safeAreaInsets.top

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heroBanner

                    Group {
                        if viewModel.isLoading {
                            HomeSkeletonView()
                                .transition(.opacity)
                        } else if let error = viewModel.errorMessage, viewModel.destinations.isEmpty {
                            ErrorStateView(message: error) { await viewModel.load() }
                                .transition(.opacity)
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
                                destinationsSection
                                categoriesSection
                                featuredSection
                                appPromoSection
                            }
                            .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut(duration: 0.35), value: viewModel.isLoading)
                }
                .scrollBounceDisabled()
            }
            // The photo runs under the status and navigation bars.
            .ignoresSafeArea(edges: .top)
            .scrollEdgeEffectHidden(true, for: .top)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                let progress = geometry.contentOffset.y / (Self.heroHeight - barBottom)
                // Hundredths are smooth to the eye and skip redundant redraws.
                return (min(max(progress, 0), 1) * 100).rounded() / 100
            } action: { _, progress in
                collapseProgress = progress
            }
        }
        .background(Color.kusiBackground)
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("KusiTrip")
                    .font(.headline)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .opacity(collapseProgress)
            }
            .sharedBackgroundVisibility(.hidden)
        }
        // Until the photo has fully turned yellow the bar stays transparent;
        // from then on it is the same solid bar as the other tabs.
        .toolbarBackground(Color.kusiPrimary, for: .navigationBar)
        .toolbarBackgroundVisibility(collapseProgress < 1 ? .hidden : .visible, for: .navigationBar)
    }

    // MARK: - Hero banner
    private var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImage(url: "https://f.civitatis.com/peru/cusco/galeria/machu-picchu.jpg")
                .frame(height: Self.heroHeight)
                // Pulling down past the top stretches the photo upward.
                .visualEffect { content, geometry in
                    let pull = max(geometry.frame(in: .scrollView).minY, 0)
                    return content.scaleEffect(1 + pull / Self.heroHeight, anchor: .bottom)
                }

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.black.opacity(0.65), .black.opacity(0.20), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(height: Self.heroHeight)

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
            // Gone by the time the photo reaches the bar.
            .opacity(Double(1 - collapseProgress * 1.6))

            // The photo turns into the bar's yellow as it collapses.
            Color.kusiPrimary
                .opacity(collapseProgress)
                .allowsHitTesting(false)
        }
        .frame(height: Self.heroHeight)
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
                LazyHStack(alignment: .top, spacing: 16) {
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
                // Room for the card shadow, which the ScrollView would otherwise clip.
                .padding(.vertical, 8)
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
}
