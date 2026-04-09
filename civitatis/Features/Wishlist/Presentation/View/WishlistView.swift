import SwiftUI
import SwiftData

struct WishlistView: View {
    @Query(sort: \FavoriteModel.savedAt, order: .reverse) private var favorites: [FavoriteModel]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if favorites.isEmpty {
                emptyState
            } else {
                favoritesList
            }
        }
        .background(Color.civBackground)
        .navigationTitle("Favoritos")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Empty state
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 64))
                .foregroundStyle(Color.civBorder)
            Text("Aún no tienes favoritos")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.civTextPrimary)
            Text("Guarda tus actividades favoritas tocando el corazón para encontrarlas fácilmente.")
                .font(.subheadline)
                .foregroundStyle(Color.civTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            NavigationLink(value: AppRoute.destinationDetail(id: "")) {
                Label("Explorar actividades", systemImage: "magnifyingglass")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.civPrimary)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Favorites list
    private var favoritesList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                Text("\(favorites.count) actividad\(favorites.count != 1 ? "es" : "") guardada\(favorites.count != 1 ? "s" : "")")
                    .font(.caption)
                    .foregroundStyle(Color.civTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                ForEach(favorites) { favorite in
                    NavigationLink(value: AppRoute.activityDetail(id: favorite.activityId)) {
                        FavoriteRowCard(favorite: favorite, onRemove: {
                            modelContext.delete(favorite)
                        })
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Favorite row card
private struct FavoriteRowCard: View {
    let favorite: FavoriteModel
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: favorite.activityImageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: Color.civBorder.overlay(ProgressView().tint(Color.civPrimary))
                }
            }
            .frame(width: 88, height: 80)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.activityTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextPrimary)
                    .lineLimit(2)

                Text(favorite.activityPrice)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.civPrimary)

                Text("Guardado el \(favorite.savedAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption2)
                    .foregroundStyle(Color.civTextSecondary)
            }
            Spacer()

            Button {
                withAnimation { onRemove() }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundStyle(Color.civDiscountRed)
            }
        }
        .padding(12)
        .civCard()
    }
}
