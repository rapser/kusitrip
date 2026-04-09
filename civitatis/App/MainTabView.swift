import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var homeNavPath      = NavigationPath()
    @State private var destNavPath      = NavigationPath()
    @State private var searchNavPath    = NavigationPath()
    @State private var wishNavPath      = NavigationPath()
    @State private var profileNavPath   = NavigationPath()

    enum Tab { case home, destinations, search, wishlist, profile }

    var body: some View {
        TabView(selection: $selectedTab) {
            // HOME
            NavigationStack(path: $homeNavPath) {
                HomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        routeDestination(route)
                    }
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }
            .tag(Tab.home)

            // DESTINATIONS
            NavigationStack(path: $destNavPath) {
                DestinationsView()
                    .navigationDestination(for: AppRoute.self) { route in
                        routeDestination(route)
                    }
            }
            .tabItem { Label("Destinos", systemImage: "map.fill") }
            .tag(Tab.destinations)

            // SEARCH
            NavigationStack(path: $searchNavPath) {
                SearchView()
                    .navigationDestination(for: AppRoute.self) { route in
                        routeDestination(route)
                    }
            }
            .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
            .tag(Tab.search)

            // WISHLIST
            NavigationStack(path: $wishNavPath) {
                WishlistView()
                    .navigationDestination(for: AppRoute.self) { route in
                        routeDestination(route)
                    }
            }
            .tabItem { Label("Favoritos", systemImage: "heart.fill") }
            .tag(Tab.wishlist)

            // PROFILE
            NavigationStack(path: $profileNavPath) {
                ProfileView()
                    .navigationDestination(for: AppRoute.self) { route in
                        routeDestination(route)
                    }
            }
            .tabItem { Label("Perfil", systemImage: "person.fill") }
            .tag(Tab.profile)
        }
        .tint(Color.civPrimary)
    }

    // MARK: - Route → View mapping
    @ViewBuilder
    private func routeDestination(_ route: AppRoute) -> some View {
        switch route {
        case .destinationDetail(let id):
            if id.isEmpty {
                DestinationsView()
            } else {
                DestinationDetailView(destinationId: id)
            }
        case .activityDetail(let id):
            ActivityDetailView(activityId: id)
        case .booking(let activityId):
            BookingView(activityId: activityId)
        case .bookingConfirmation(let bookingId, let title, let price):
            BookingConfirmationView(
                confirmation: BookingConfirmationUI(
                    id: UUID().uuidString,
                    bookingId: bookingId,
                    activityTitle: title,
                    formattedDate: "-",
                    formattedTime: "-",
                    numberOfPeopleText: "-",
                    formattedTotal: "S/ \(String(format: "%.2f", price))",
                    confirmedAt: "-"
                )
            )
        }
    }
}
