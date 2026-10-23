import SwiftUI

// The image is an overlay on a flexible rectangle so a fill-scaled photo never
// widens its container beyond the size the parent proposes.
struct RemoteImage: View {
    let url: String

    var body: some View {
        Rectangle()
            .fill(Color.kusiBorder.opacity(0.4))
            .overlay {
                // The transaction fades the photo in instead of popping it.
                AsyncImage(url: URL(string: url), transaction: Transaction(animation: .easeOut(duration: 0.3))) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .transition(.opacity)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(Color.kusiTextSecondary)
                    default:
                        Color.kusiBorder.opacity(0.3)
                            .kusiShimmer()
                    }
                }
                .allowsHitTesting(false)
            }
            .clipped()
    }
}
