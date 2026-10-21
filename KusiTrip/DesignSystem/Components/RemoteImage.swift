import SwiftUI

// The image is an overlay on a flexible rectangle so a fill-scaled photo never
// widens its container beyond the size the parent proposes.
struct RemoteImage: View {
    let url: String

    var body: some View {
        Rectangle()
            .fill(Color.kusiBorder.opacity(0.4))
            .overlay {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(Color.kusiTextSecondary)
                    default:
                        ProgressView()
                            .tint(Color.kusiTextPrimary)
                    }
                }
                .allowsHitTesting(false)
            }
            .clipped()
    }
}
