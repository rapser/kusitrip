import SwiftUI

struct ActivityCard: View {
    let activity: ActivityUI
    var isFavorited: Bool = false
    let onFavorite: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            contentSection
        }
        .civCard()
        .frame(width: 248)
    }

    // MARK: - Image section
    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: activity.primaryImageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.kusiBorder)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(Color.kusiTextSecondary)
                        )
                default:
                    Rectangle()
                        .fill(Color.kusiBorder.opacity(0.4))
                        .overlay(ProgressView().tint(Color.kusiTextPrimary))
                }
            }
            .frame(height: 160)
            .clipped()

            // Favorite button
            Button(action: { onFavorite(activity.id) }) {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isFavorited ? Color.kusiDiscountRed : .white)
                    .padding(8)
                    .background(Color.black.opacity(0.25))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(8)

            // Free cancellation badge — bottom of image
            if activity.hasFreeCancel {
                VStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                        Text("Cancelación gratuita")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(Color.kusiTextPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.kusiPrimary)
                    .padding([.leading, .bottom], 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 160)
    }

    // MARK: - Content section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Category tag
            Text(activity.categoryLabel)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.kusiTextPrimary)

            // Title
            Text(activity.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.kusiTextPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            // Rating + duration row
            HStack(spacing: 6) {
                StarRatingView(rating: activity.ratingValue)
                Text(activity.ratingText)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
                Text("·")
                    .foregroundStyle(Color.kusiBorder)
                Text(activity.reviewCountText)
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
                    .lineLimit(1)
                Spacer()
            }

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption2)
                    .foregroundStyle(Color.kusiTextSecondary)
                Text(activity.durationText)
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
                Spacer()
            }

            Divider()

            // Price
            if activity.isFree {
                Text("¡Gratis!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    if let original = activity.formattedOriginalPrice,
                       let pct = activity.discountPercentage {
                        HStack(spacing: 6) {
                            Text(original)
                                .font(.caption)
                                .foregroundStyle(Color.kusiTextSecondary)
                                .strikethrough(color: Color.kusiTextSecondary)
                            Text("-\(pct)%")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.kusiDiscountRed)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text("desde")
                            .font(.caption)
                            .foregroundStyle(Color.kusiTextSecondary)
                        Text(activity.formattedPrice)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.kusiTextPrimary)
                    }
                }
            }
        }
        .padding(12)
    }
}
