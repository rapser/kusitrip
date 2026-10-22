import SwiftUI
import SwiftData

struct ActivityDetailView: View {
    let activityId: String
    @State private var viewModel = ActivityDetailViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteModel]

    var isFavorited: Bool {
        favorites.contains(where: { $0.activityId == activityId })
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.kusiTextPrimary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let activity = viewModel.activity {
                content(activity)
            } else if let error = viewModel.errorMessage {
                ErrorStateView(message: error) { await viewModel.load(activityId: activityId) }
            }
        }
        .background(Color.kusiBackground)
        .task { await viewModel.load(activityId: activityId) }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let activity = viewModel.activity {
                    Button {
                        toggleFavorite(activity)
                    } label: {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorited ? Color.kusiDiscountRed : Color.kusiTextPrimary)
                    }
                }
            }
        }
    }

    // MARK: - Main content
    @ViewBuilder
    private func content(_ activity: ActivityUI) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                gallerySection(activity)
                headerSection(activity)
                descriptionSection(activity)
                detailsSection(activity)
                reviewsSection
                relatedSection
                Spacer(minLength: 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bookingBar(activity)
        }
    }

    // MARK: - Gallery
    private func gallerySection(_ activity: ActivityUI) -> some View {
        TabView(selection: $viewModel.currentImageIndex) {
            ForEach(Array(activity.imageURLs.enumerated()), id: \.offset) { index, url in
                RemoteImage(url: url)
                    .tag(index)
            }
        }
        .frame(height: 280)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    // MARK: - Header
    private func headerSection(_ activity: ActivityUI) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(activity.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.kusiTextPrimary)

            HStack(spacing: 8) {
                StarRatingView(rating: activity.ratingValue)
                Text(activity.ratingText)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
                Text("·")
                    .foregroundStyle(Color.kusiBorder)
                Text(activity.reviewCountText)
                    .font(.subheadline)
                    .foregroundStyle(Color.kusiTextSecondary)
            }

            HStack(spacing: 8) {
                Label(activity.travelerCountText, systemImage: "figure.walk")
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
            }

            HStack(spacing: 8) {
                if activity.hasFreeCancel {
                    Label("Cancelación gratuita", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.kusiTextPrimary)
                }
                Label(activity.durationText, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
                Label(activity.categoryLabel, systemImage: activity.categoryIcon)
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
            }
        }
        .padding(16)
        .background(Color.kusiSurface)
    }

    // MARK: - Description
    private func descriptionSection(_ activity: ActivityUI) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Descripción")
                .font(.headline)
                .foregroundStyle(Color.kusiTextPrimary)
            Text(activity.fullDescription)
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
                .lineLimit(viewModel.isDescriptionExpanded ? nil : 4)
            Button(viewModel.isDescriptionExpanded ? "Ver menos" : "Ver más") {
                withAnimation { viewModel.isDescriptionExpanded.toggle() }
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color.kusiTextPrimary)
        }
        .padding(16)

    }

    // MARK: - Details
    private func detailsSection(_ activity: ActivityUI) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Detalles")
                .font(.headline)
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            Divider()

            detailRow(icon: "clock", title: "Duración", value: activity.durationText)
            Divider().padding(.leading, 52)
            detailRow(icon: "globe", title: "Idioma", value: "Guía en español")
            Divider().padding(.leading, 52)
            detailRow(icon: "mappin.circle", title: "Punto de encuentro", value: activity.meetingPoint)
            Divider().padding(.leading, 52)
            if activity.hasFreeCancel {
                detailRow(icon: "checkmark.circle", title: "Cancelación", value: "Gratuita")
                Divider().padding(.leading, 52)
            }
            // Includes
            VStack(alignment: .leading, spacing: 8) {
                Label("Incluido", systemImage: "checkmark.seal")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.kusiTextPrimary)
                ForEach(activity.includes, id: \.self) { include in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.kusiTextPrimary)
                            .font(.caption)
                            .padding(.top, 2)
                        Text(include)
                            .font(.subheadline)
                            .foregroundStyle(Color.kusiTextSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.kusiSurface)
        .padding(.top, 8)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.kusiTextPrimary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(Color.kusiTextPrimary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Reviews
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Opiniones")
                    .font(.headline)
                    .foregroundStyle(Color.kusiTextPrimary)
                Spacer()
                Text("\(viewModel.reviews.count) reseñas")
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            if viewModel.reviews.isEmpty {
                Text("Sé el primero en opinar sobre esta actividad.")
                    .font(.subheadline)
                    .foregroundStyle(Color.kusiTextSecondary)
                    .padding(.horizontal, 16)
            } else {
                ForEach(viewModel.reviews.prefix(3)) { review in
                    ReviewCard(review: review)
                        .padding(.horizontal, 16)
                }
            }
        }
        .padding(.bottom, 8)
    }

    // MARK: - Related
    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("También te puede interesar")
                .font(.headline)
                .foregroundStyle(Color.kusiTextPrimary)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            if viewModel.relatedActivities.isEmpty {
                Text("No hay actividades relacionadas.")
                    .font(.subheadline)
                    .foregroundStyle(Color.kusiTextSecondary)
                    .padding(.horizontal, 16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(viewModel.relatedActivities) { related in
                            NavigationLink(value: AppRoute.activityDetail(id: related.id)) {
                                ActivityCard(
                                    activity: related,
                                    isFavorited: favorites.contains(where: { $0.activityId == related.id }),
                                    onFavorite: { _ in toggleFavorite(related) }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.bottom, 12)
    }

    // MARK: - Booking bar
    private func bookingBar(_ activity: ActivityUI) -> some View {
        HStack(spacing: 12) {
            PriceTagView(activity: activity)
            Spacer()
            NavigationLink(value: AppRoute.booking(activityId: activityId)) {
                Text("Reservar")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.kusiPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.kusiSurface)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.kusiBorder), alignment: .top)
    }

    // MARK: - Toggle favorite
    private func toggleFavorite(_ activity: ActivityUI) {
        let isFavorite = modelContext.toggleFavorite(activity)
        Task {
            await EventBus.shared.send(.favoriteToggled(activityId: activity.id, isFavorite: isFavorite))
        }
    }
}

// MARK: - ReviewCard
private struct ReviewCard: View {
    let review: ReviewUI

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(Color.kusiTextPrimary.opacity(0.12))
                    Text(review.initials)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.kusiTextPrimary)
                }
                .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.authorName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.kusiTextPrimary)
                    Text(review.city)
                        .font(.caption)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(review.ratingText)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.kusiTextPrimary)
                    Text(review.date)
                        .font(.caption2)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
            }
            Text(review.comment)
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
                .lineLimit(4)
            HStack(spacing: 4) {
                Image(systemName: review.travelTypeIcon)
                    .font(.caption2)
                    .foregroundStyle(Color.kusiTextSecondary)
                Text(review.travelTypeLabel)
                    .font(.caption2)
                    .foregroundStyle(Color.kusiTextSecondary)
            }
        }
        .padding(14)
        .kusiCard()
    }
}
