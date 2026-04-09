import SwiftUI
import SwiftData

struct DestinationDetailView: View {
    let destinationId: String
    @State private var viewModel = DestinationDetailViewModel()
    @Query private var favorites: [FavoriteModel]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                if let dest = viewModel.destination {
                    heroSection(dest)
                    infoSection(dest)
                }

                categoryFilters

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .tint(Color.civPrimary)
                } else if viewModel.filteredActivities.isEmpty {
                    emptyActivities
                } else {
                    activitiesList
                }
            }
        }
        .background(Color.civBackground)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load(destinationId: destinationId) }
    }

    // MARK: Hero
    private func heroSection(_ dest: DestinationUI) -> some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: dest.imageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: Color.civPrimary
                }
            }
            .frame(height: 220)
            .clipped()

            LinearGradient(
                colors: [.black.opacity(0.65), .clear],
                startPoint: .bottom,
                endPoint: .center
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(dest.name)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                Text(dest.country)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(height: 220)
    }

    // MARK: Info
    private func infoSection(_ dest: DestinationUI) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 16) {
                statBadge(icon: "figure.walk", text: dest.travelerCountText)
                statBadge(icon: "star.fill", text: dest.ratingText)
                statBadge(icon: "ticket", text: dest.activityCountText)
            }

            Text(dest.description)
                .font(.subheadline)
                .foregroundStyle(Color.civTextSecondary)
                .lineLimit(3)
        }
        .padding(16)
        .background(Color.civSurface)
    }

    private func statBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(Color.civPrimary)
            Text(text)
                .font(.caption2)
                .foregroundStyle(Color.civTextSecondary)
        }
    }

    // MARK: Category filter
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.availableCategories) { cat in
                    CategoryChipView(
                        category: cat,
                        isSelected: viewModel.selectedCategory == cat.id
                    ) {
                        viewModel.selectCategory(cat.id)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    // MARK: Activities list
    private var activitiesList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredActivities) { activity in
                NavigationLink(value: AppRoute.activityDetail(id: activity.id)) {
                    ActivityRowCard(
                        activity: activity,
                        isFavorited: favorites.contains(where: { $0.activityId == activity.id })
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    private var emptyActivities: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(Color.civBorder)
            Text("No hay actividades en esta categoría")
                .font(.subheadline)
                .foregroundStyle(Color.civTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

// MARK: - Row card
private struct ActivityRowCard: View {
    let activity: ActivityUI
    var isFavorited: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: activity.primaryImageURL)) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: Color.civBorder.overlay(ProgressView().tint(Color.civPrimary))
                }
            }
            .frame(width: 100, height: 90)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text(activity.categoryLabel)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civPrimary)
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextPrimary)
                    .lineLimit(2)
                HStack(spacing: 4) {
                    StarRatingView(rating: activity.ratingValue)
                    Text(activity.ratingText)
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("·")
                        .foregroundStyle(Color.civBorder)
                    Text(activity.reviewCountText)
                        .font(.caption)
                        .foregroundStyle(Color.civTextSecondary)
                }
                HStack(spacing: 4) {
                    if activity.hasFreeCancel {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(Color.civPrimary)
                        Text("Cancelación gratuita")
                            .font(.caption2)
                            .foregroundStyle(Color.civPrimary)
                    }
                }
                if activity.isFree {
                    Text("¡Gratis!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.civPrimary)
                } else {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        if let pct = activity.discountPercentage {
                            Text("-\(pct)%")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 4).padding(.vertical, 2)
                                .background(Color.civDiscountRed)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                        Text(activity.formattedPrice)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.civTextPrimary)
                    }
                }
            }
            Spacer()
        }
        .padding(12)
        .civCard()
    }
}
