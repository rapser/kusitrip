import SwiftUI

struct ActivityCard: View {
    static let width: CGFloat = 248
    private static let imageHeight: CGFloat = 160
    private static let height: CGFloat = 348

    let activity: ActivityUI
    var isFavorited: Bool = false
    let onFavorite: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            contentSection
        }
        // Size is fixed before the card background is applied, so neither the
        // photo nor the background can grow past the cell and overlap its neighbours.
        .frame(width: Self.width, height: Self.height, alignment: .top)
        .kusiCard()
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.kusiBorder))
    }

    // MARK: - Image section
    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            RemoteImage(url: activity.primaryImageURL)
                .frame(width: Self.width, height: Self.imageHeight)

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
        .frame(width: Self.width, height: Self.imageHeight)
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
                .lineLimit(2, reservesSpace: true)

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

            Spacer(minLength: 0)

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
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
