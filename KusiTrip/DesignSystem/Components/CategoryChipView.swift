import SwiftUI

struct CategoryChipView: View {
    let category: CategoryUI
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 13))
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.kusiPrimary : Color.kusiSurface)
            .foregroundStyle(Color.kusiTextPrimary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isSelected ? Color.kusiPrimary : Color.kusiBorder, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        CategoryChipView(
            category: CategoryUI(id: "guided", name: "Visitas guiadas", icon: "person.2"),
            isSelected: true,
            onTap: {}
        )
        CategoryChipView(
            category: CategoryUI(id: "free", name: "Free Tours", icon: "star.circle"),
            isSelected: false,
            onTap: {}
        )
    }
    .padding()
}
