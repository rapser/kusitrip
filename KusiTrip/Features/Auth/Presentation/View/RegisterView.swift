import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "person.badge.plus")
                .font(.system(size: 72))
                .foregroundStyle(Color.kusiTextPrimary)
            VStack(spacing: 12) {
                Text("Crea tu cuenta")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.kusiTextPrimary)
                Text("El registro estará disponible\npróximamente en esta versión.")
                    .font(.body)
                    .foregroundStyle(Color.kusiTextSecondary)
                    .multilineTextAlignment(.center)
            }
            PrimaryButton(title: "Volver al inicio de sesión") {
                dismiss()
            }
            Spacer()
        }
        .padding(32)
        .background(Color.kusiBackground)
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
    }
}
