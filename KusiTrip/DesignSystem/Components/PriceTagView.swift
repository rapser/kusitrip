import SwiftUI

struct PriceTagView: View {
    let activity: ActivityUI

    var body: some View {
        if activity.isFree {
            Text("¡Gratis!")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.kusiTextPrimary)
        } else {
            VStack(alignment: .leading, spacing: 2) {
                if let original = activity.formattedOriginalPrice,
                   let pct = activity.discountPercentage {
                    HStack(spacing: 6) {
                        Text(original)
                            .font(.footnote)
                            .foregroundStyle(Color.kusiTextSecondary)
                            .strikethrough(color: Color.kusiTextSecondary)
                        Text("-\(pct)%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.kusiDiscountRed)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                }
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("desde")
                        .font(.caption)
                        .foregroundStyle(Color.kusiTextSecondary)
                    Text(activity.formattedPrice)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.kusiTextPrimary)
                }
            }
        }
    }
}
