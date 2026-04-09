import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "person.badge.plus")
                .font(.system(size: 72))
                .foregroundStyle(Color.civPrimary)
            VStack(spacing: 12) {
                Text("Crea tu cuenta")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.civTextPrimary)
                Text("El registro estará disponible\npróximamente en esta versión.")
                    .font(.body)
                    .foregroundStyle(Color.civTextSecondary)
                    .multilineTextAlignment(.center)
            }
            PrimaryButton(title: "Volver al inicio de sesión") {
                dismiss()
            }
            Spacer()
        }
        .padding(32)
        .background(Color.civBackground)
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
    }
}
