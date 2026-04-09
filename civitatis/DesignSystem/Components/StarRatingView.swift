import SwiftUI

struct StarRatingView: View {
    let rating: Double  // scale 0-10

    private var stars: Double { rating / 2.0 }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: starName(for: index))
                    .font(.system(size: 11))
                    .foregroundStyle(Color.civRatingGold)
            }
        }
    }

    private func starName(for index: Int) -> String {
        let value = stars - Double(index - 1)
        if value >= 1.0 { return "star.fill" }
        if value >= 0.5 { return "star.leadinghalf.filled" }
        return "star"
    }
}

#Preview {
    HStack {
        StarRatingView(rating: 9.3)
        StarRatingView(rating: 7.5)
        StarRatingView(rating: 5.0)
    }
    .padding()
}
