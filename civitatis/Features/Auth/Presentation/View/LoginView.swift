import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                formSection
                footerSection
            }
        }
        .background(Color.civBackground)
        .scrollBounceBehavior(.basedOnSize)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            Color.civPrimary
                .frame(height: 240)

            VStack(spacing: 8) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.white)
                Text("civitatis")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(.white)
                Text("Visitas guiadas y excursiones en español")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 32)
        }
    }

    // MARK: - Form
    private var formSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 24) {
                Text("Iniciar sesión")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.civTextPrimary)

                // Email field
                VStack(alignment: .leading, spacing: 6) {
                    Label("Correo electrónico", systemImage: "envelope")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.civTextSecondary)
                    TextField("email@ejemplo.com", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.civSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.civBorder))
                }

                // Password field
                VStack(alignment: .leading, spacing: 6) {
                    Label("Contraseña", systemImage: "lock")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.civTextSecondary)
                    HStack {
                        Group {
                            if viewModel.showPassword {
                                TextField("Contraseña", text: $viewModel.password)
                            } else {
                                SecureField("Contraseña", text: $viewModel.password)
                            }
                        }
                        .textContentType(.password)
                        .autocorrectionDisabled()
                        Button {
                            viewModel.showPassword.toggle()
                        } label: {
                            Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color.civTextSecondary)
                        }
                    }
                    .padding()
                    .background(Color.civSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.civBorder))
                }

                // Error
                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.civDiscountRed)
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(Color.civDiscountRed)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.civDiscountRed.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // Forgot password
                HStack {
                    Spacer()
                    Button("¿Olvidaste tu contraseña?") {}
                        .font(.footnote)
                        .foregroundStyle(Color.civPrimary)
                }

                // Login button
                PrimaryButton(title: "Iniciar sesión", isLoading: viewModel.isLoading) {
                    await viewModel.login()
                }
            }
            .padding(24)
            .background(Color.civSurface)
            .clipShape(
                UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
            )
        }
        .padding(.top, -20)
    }

    // MARK: - Footer
    private var footerSection: some View {
        VStack(spacing: 20) {
            HStack {
                Rectangle().fill(Color.civBorder).frame(height: 1)
                Text("o")
                    .font(.footnote)
                    .foregroundStyle(Color.civTextSecondary)
                    .padding(.horizontal, 10)
                Rectangle().fill(Color.civBorder).frame(height: 1)
            }

            NavigationLink(destination: RegisterView()) {
                HStack(spacing: 0) {
                    Text("¿Primera vez en Civitatis? ")
                        .foregroundStyle(Color.civTextSecondary)
                    Text("Regístrate")
                        .foregroundStyle(Color.civPrimary)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
            }

            // Demo hint
            VStack(spacing: 4) {
                Text("Credenciales de demo")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextSecondary)
                Text("usuario@civitatis.com  ·  civitatis123")
                    .font(.caption2)
                    .foregroundStyle(Color.civTextSecondary)
                    .fontDesign(.monospaced)
            }
            .padding(10)
            .background(Color.civBorder.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(Color.civSurface)
        .padding(.bottom, 20)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
