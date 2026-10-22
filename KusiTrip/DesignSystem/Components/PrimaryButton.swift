import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () async -> Void

    var body: some View {
        Button {
            Task { await action() }
        } label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(Color.kusiTextPrimary)
                        .scaleEffect(0.9)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isDisabled ? Color.kusiBorder : Color.kusiPrimary)
            .foregroundStyle(Color.kusiTextPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(isLoading || isDisabled)
    }
}
