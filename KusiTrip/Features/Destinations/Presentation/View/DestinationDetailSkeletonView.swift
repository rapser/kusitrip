import SwiftUI

/// Placeholder for the whole destination screen (photo, stats, description,
/// category chips and activity rows) while it loads.
struct DestinationDetailSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.kusiBorder.opacity(0.55)
                .frame(height: 220)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 16) {
                    ForEach([70, 44, 84], id: \.self) { width in
                        SkeletonBlock(width: CGFloat(width), height: 10, cornerRadius: 4)
                    }
                }
                SkeletonBlock(height: 12, cornerRadius: 4)
                SkeletonBlock(height: 12, cornerRadius: 4)
                SkeletonBlock(width: 200, height: 12, cornerRadius: 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.kusiSurface)

            SkeletonCarousel(spacing: 10) {
                ForEach([80, 128, 104, 96], id: \.self) { width in
                    SkeletonBlock(width: CGFloat(width), height: 38, cornerRadius: 19)
                }
            }
            .padding(.vertical, 12)

            VStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in activityRow }
            }
            .padding(.horizontal, 16)
        }
        .kusiShimmer()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando destino")
    }

    /// Same size as `ActivityRowCard`.
    private var activityRow: some View {
        HStack(alignment: .top, spacing: 12) {
            SkeletonBlock(width: 100, height: 90, cornerRadius: 10)
            VStack(alignment: .leading, spacing: 8) {
                SkeletonBlock(width: 60, height: 9, cornerRadius: 4)
                SkeletonBlock(height: 13, cornerRadius: 5)
                SkeletonBlock(width: 140, height: 13, cornerRadius: 5)
                SkeletonBlock(width: 110, height: 10, cornerRadius: 4)
                SkeletonBlock(width: 70, height: 14, cornerRadius: 5)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .kusiCard()
    }
}

#Preview {
    ScrollView {
        DestinationDetailSkeletonView()
    }
    .background(Color.kusiBackground)
}
