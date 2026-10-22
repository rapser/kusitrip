import SwiftUI

/// Inline error message for failed API calls, with an optional retry action.
struct ErrorStateView: View {
    let message: String
    var retry: (() async -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 36))
                .foregroundStyle(Color.kusiTextSecondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
                .multilineTextAlignment(.center)
            if let retry {
                PrimaryButton(title: "Reintentar", action: retry)
                    .frame(maxWidth: 220)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
    }
}
