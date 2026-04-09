import SwiftUI

struct DestinationCard: View {
    let destination: DestinationUI

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: destination.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle().fill(Color.civBorder)
                default:
                    Rectangle()
                        .fill(Color.civBorder.opacity(0.4))
                        .overlay(ProgressView().tint(Color.civPrimary))
                }
            }
            .frame(width: 160, height: 200)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.72)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(destination.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text(destination.activityCountText)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.88))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
        .frame(width: 160, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
