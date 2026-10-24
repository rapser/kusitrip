import SwiftUI

/// Gray placeholder with the size and shape of the content that is loading.
/// Group several blocks in a container and apply `.kusiShimmer()` once to the
/// container, so a single highlight sweeps across all of them in sync.
struct SkeletonBlock: View {
    var width: CGFloat?
    var height: CGFloat
    var cornerRadius: CGFloat = 8

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.kusiBorder.opacity(0.55))
            .frame(width: width, height: height)
    }
}

/// Horizontal row of skeleton blocks that, like the real carousels, runs past
/// the screen edge. The disabled ScrollView keeps the overflow from widening
/// the page.
struct SkeletonCarousel<Content: View>: View {
    var spacing: CGFloat = 12
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) { content }
                .padding(.horizontal, 16)
        }
        .scrollDisabled(true)
    }
}

extension View {
    /// Sweeps a soft highlight across the view's opaque shapes while it is
    /// visible. Static with Reduce Motion.
    func kusiShimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

private struct ShimmerModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceMotion {
                    GeometryReader { proxy in
                        let bandWidth = max(proxy.size.width * 0.45, 120)
                        LinearGradient(
                            colors: [.white.opacity(0), .white.opacity(0.6), .white.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: bandWidth)
                        .offset(x: -bandWidth + phase * (proxy.size.width + bandWidth))
                    }
                    .mask { content }
                    .allowsHitTesting(false)
                }
            }
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 1.3).delay(0.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        SkeletonBlock(width: 180, height: 20)
        SkeletonBlock(height: 160, cornerRadius: 14)
        SkeletonBlock(width: 120, height: 14)
    }
    .padding()
    .kusiShimmer()
}
