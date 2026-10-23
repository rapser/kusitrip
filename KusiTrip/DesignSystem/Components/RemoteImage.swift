import SwiftUI

// The image is an overlay on a flexible rectangle so a fill-scaled photo never
// widens its container beyond the size the parent proposes.
//
// Photos come from `RemoteImageLoader`: cached ones show on the first frame;
// the rest shimmer while downloading, fade in, and retry twice before showing
// the "no photo" icon.
struct RemoteImage: View {
    let url: String

    private enum Phase {
        case loading
        case loaded(UIImage)
        case failed
    }

    private static let retryDelays: [Duration] = [.seconds(1), .seconds(3)]

    @State private var phase: Phase

    init(url: String) {
        self.url = url
        let cached = URL(string: url).flatMap { RemoteImageLoader.shared.cachedImage(for: $0) }
        _phase = State(initialValue: cached.map(Phase.loaded) ?? .loading)
    }

    var body: some View {
        Rectangle()
            .fill(Color.kusiBorder.opacity(0.4))
            .overlay {
                switch phase {
                case .loaded(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                case .failed:
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(Color.kusiTextSecondary)
                case .loading:
                    Color.kusiBorder.opacity(0.3)
                        .kusiShimmer()
                }
            }
            .allowsHitTesting(false)
            .clipped()
            .task(id: url) { await load() }
    }

    private func load() async {
        guard let imageURL = URL(string: url) else {
            phase = .failed
            return
        }
        if let cached = RemoteImageLoader.shared.cachedImage(for: imageURL) {
            phase = .loaded(cached)
            return
        }
        phase = .loading

        for attempt in 0...Self.retryDelays.count {
            do {
                let image = try await RemoteImageLoader.shared.image(for: imageURL)
                withAnimation(.easeOut(duration: 0.3)) { phase = .loaded(image) }
                return
            } catch {
                guard !Task.isCancelled, attempt < Self.retryDelays.count else { break }
                try? await Task.sleep(for: Self.retryDelays[attempt])
            }
        }
        if !Task.isCancelled { phase = .failed }
    }
}
