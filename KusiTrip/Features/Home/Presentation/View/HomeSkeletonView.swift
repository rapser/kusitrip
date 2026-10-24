import SwiftUI

/// Placeholder for the Home sections while their data loads. It mirrors the
/// real layout (sizes, spacing, card shapes) so the content replaces it in
/// place, without the page jumping.
struct HomeSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(titleWidth: 190, trailingWidth: 60)
            SkeletonCarousel(spacing: 12) {
                ForEach(0..<3, id: \.self) { _ in
                    SkeletonBlock(width: 160, height: 200, cornerRadius: 14)
                }
            }

            sectionHeader(titleWidth: 170)
            SkeletonCarousel(spacing: 10) {
                ForEach([128, 104, 140, 96], id: \.self) { width in
                    SkeletonBlock(width: CGFloat(width), height: 40, cornerRadius: 20)
                }
            }

            sectionHeader(titleWidth: 200)
            SkeletonCarousel(spacing: 16) {
                ForEach(0..<2, id: \.self) { _ in activityCard }
            }
            .padding(.vertical, 8)
        }
        .padding(.bottom, 24)
        .kusiShimmer()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando destinos")
    }

    private func sectionHeader(titleWidth: CGFloat, trailingWidth: CGFloat? = nil) -> some View {
        HStack {
            SkeletonBlock(width: titleWidth, height: 20, cornerRadius: 6)
            Spacer()
            if let trailingWidth {
                SkeletonBlock(width: trailingWidth, height: 14, cornerRadius: 5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    private var activityCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBlock(height: 160, cornerRadius: 0)
            VStack(alignment: .leading, spacing: 10) {
                SkeletonBlock(width: 70, height: 10, cornerRadius: 4)
                SkeletonBlock(height: 14, cornerRadius: 5)
                SkeletonBlock(width: 160, height: 14, cornerRadius: 5)
                SkeletonBlock(width: 130, height: 12, cornerRadius: 4)
                Spacer(minLength: 0)
                SkeletonBlock(width: 110, height: 18, cornerRadius: 5)
            }
            .padding(12)
        }
        .frame(width: ActivityCard.width, height: ActivityCard.height, alignment: .top)
        .background(Color.kusiSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.kusiBorder))
    }
}

#Preview {
    ScrollView {
        HomeSkeletonView()
    }
    .background(Color.kusiBackground)
}
