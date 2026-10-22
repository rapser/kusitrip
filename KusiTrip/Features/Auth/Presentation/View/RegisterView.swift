import SwiftUI

struct RegisterView: View {
    @State private var viewModel = RegisterViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Crea tu cuenta")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.kusiTextPrimary)
                    Text("Guarda tus favoritos y reserva tus próximas experiencias.")
                        .font(.subheadline)
                        .foregroundStyle(Color.kusiTextSecondary)
                }

                HStack(spacing: 12) {
                    field("Nombre", icon: "person", placeholder: "Miguel", text: $viewModel.name)
                        .textContentType(.givenName)
                    field("Apellido", icon: "person", placeholder: "Tomairo", text: $viewModel.surname)
                        .textContentType(.familyName)
                }

                field("Correo electrónico", icon: "envelope", placeholder: "email@ejemplo.com", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)

                field("Contraseña", icon: "lock", placeholder: "Mínimo 8 caracteres", text: $viewModel.password, isSecure: true)
                    .textContentType(.newPassword)

                field("Repite la contraseña", icon: "lock", placeholder: "Contraseña", text: $viewModel.passwordConfirmation, isSecure: true)
                    .textContentType(.newPassword)

                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.kusiDiscountRed)
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(Color.kusiDiscountRed)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.kusiDiscountRed.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                PrimaryButton(title: "Crear cuenta", isLoading: viewModel.isLoading) {
                    await viewModel.register()
                }
            }
            .padding(24)
        }
        .background(Color.kusiSurface)
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .kusiLoadingOverlay(isPresented: viewModel.isLoading, message: "Creando tu cuenta…")
    }

    private func field(
        _ title: String,
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color.kusiTextSecondary)
            ZStack(alignment: .leading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
                Group {
                    if isSecure {
                        SecureField("", text: text)
                    } else {
                        TextField("", text: text)
                    }
                }
                .foregroundStyle(Color.kusiTextPrimary)
                .tint(Color.kusiTextPrimary)
                .autocorrectionDisabled()
            }
            .padding()
            .background(Color.kusiSurface)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.kusiBorder))
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
