import SwiftUI

/// Placeholder for the activity screen (gallery, header, description, details
/// and booking bar) while it loads.
struct ActivityDetailSkeletonView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Color.kusiBorder.opacity(0.55)
                    .frame(height: 280)

                VStack(alignment: .leading, spacing: 12) {
                    SkeletonBlock(height: 20, cornerRadius: 6)
                    SkeletonBlock(width: 220, height: 20, cornerRadius: 6)
                    SkeletonBlock(width: 180, height: 12, cornerRadius: 4)
                    SkeletonBlock(width: 120, height: 10, cornerRadius: 4)
                    HStack(spacing: 8) {
                        ForEach([130, 70, 90], id: \.self) { width in
                            SkeletonBlock(width: CGFloat(width), height: 10, cornerRadius: 4)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.kusiSurface)

                VStack(alignment: .leading, spacing: 10) {
                    SkeletonBlock(width: 110, height: 16, cornerRadius: 5)
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonBlock(height: 12, cornerRadius: 4)
                    }
                    SkeletonBlock(width: 200, height: 12, cornerRadius: 4)
                }
                .padding(16)

                VStack(alignment: .leading, spacing: 0) {
                    SkeletonBlock(width: 80, height: 16, cornerRadius: 5)
                        .padding(16)
                    ForEach(0..<3, id: \.self) { _ in detailRow }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.kusiSurface)
                .padding(.top, 8)
            }
            .kusiShimmer()
        }
        .scrollDisabled(true)
        .safeAreaInset(edge: .bottom) { bookingBar }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando actividad")
    }

    private var detailRow: some View {
        HStack(spacing: 12) {
            SkeletonBlock(width: 24, height: 24, cornerRadius: 12)
            VStack(alignment: .leading, spacing: 6) {
                SkeletonBlock(width: 70, height: 9, cornerRadius: 4)
                SkeletonBlock(width: 150, height: 12, cornerRadius: 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    /// Same height as the real booking bar, so the screen does not jump.
    private var bookingBar: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                SkeletonBlock(width: 50, height: 10, cornerRadius: 4)
                SkeletonBlock(width: 90, height: 18, cornerRadius: 5)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.kusiPrimary.opacity(0.45))
                .frame(width: 130, height: 48)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .kusiShimmer()
        .background(Color.kusiSurface)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.kusiBorder), alignment: .top)
    }
}

#Preview {
    ActivityDetailSkeletonView()
        .background(Color.kusiBackground)
}
