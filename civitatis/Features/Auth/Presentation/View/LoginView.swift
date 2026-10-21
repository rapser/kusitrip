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
        .background(Color.kusiSurface)
        .scrollBounceBehavior(.basedOnSize)
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            Color.kusiPrimary
                .frame(height: 240)

            VStack(spacing: 8) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(Color.kusiTextPrimary)
                Text("Kusi Trip")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(Color.kusiTextPrimary)
                Text("Visitas guiadas y excursiones en español")
                    .font(.subheadline)
                    .foregroundStyle(Color.kusiTextPrimary.opacity(0.8))
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
                    .foregroundStyle(Color.kusiTextPrimary)

                // Email field
                VStack(alignment: .leading, spacing: 6) {
                    Label("Correo electrónico", systemImage: "envelope")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.kusiTextSecondary)
                    ZStack(alignment: .leading) {
                        if viewModel.email.isEmpty {
                            Text("email@ejemplo.com")
                                .foregroundStyle(Color.kusiTextSecondary)
                                .tint(Color.kusiTextSecondary)
                        }
                        TextField("", text: $viewModel.email)
                            .foregroundStyle(Color.kusiTextPrimary)
                            .tint(Color.kusiTextPrimary)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    .padding()
                    .background(Color.kusiSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.kusiBorder))
                }

                // Password field
                VStack(alignment: .leading, spacing: 6) {
                    Label("Contraseña", systemImage: "lock")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.kusiTextSecondary)
                    HStack {
                        ZStack(alignment: .leading) {
                            if viewModel.password.isEmpty {
                                Text("Contraseña")
                                    .foregroundStyle(Color.kusiTextSecondary)
                            }
                            Group {
                                if viewModel.showPassword {
                                    TextField("", text: $viewModel.password)
                                } else {
                                    SecureField("", text: $viewModel.password)
                                }
                            }
                            .foregroundStyle(Color.kusiTextPrimary)
                            .tint(Color.kusiTextPrimary)
                            .textContentType(.password)
                            .autocorrectionDisabled()
                        }
                        Button {
                            viewModel.showPassword.toggle()
                        } label: {
                            Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color.kusiTextSecondary)
                        }
                    }
                    .padding()
                    .background(Color.kusiSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.kusiBorder))
                }

                // Error
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

                // Forgot password
                HStack {
                    Spacer()
                    Button("¿Olvidaste tu contraseña?") {}
                        .font(.footnote)
                        .foregroundStyle(Color.kusiTextPrimary)
                }

                // Login button
                PrimaryButton(title: "Iniciar sesión", isLoading: viewModel.isLoading) {
                    await viewModel.login()
                }
            }
            .padding(24)
            .background(Color.kusiSurface)
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
                Rectangle().fill(Color.kusiBorder).frame(height: 1)
                Text("o")
                    .font(.footnote)
                    .foregroundStyle(Color.kusiTextSecondary)
                    .padding(.horizontal, 10)
                Rectangle().fill(Color.kusiBorder).frame(height: 1)
            }

            NavigationLink(destination: RegisterView()) {
                HStack(spacing: 0) {
                    Text("¿Primera vez en Kusi Trip? ")
                        .foregroundStyle(Color.kusiTextSecondary)
                    Text("Regístrate")
                        .foregroundStyle(Color.kusiTextPrimary)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
            }

            // Demo hint
            VStack(spacing: 4) {
                Text("Credenciales de demo")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.kusiTextSecondary)
                Text("usuario@kusitrip.com  ·  kusitrip123")
                    .font(.caption2)
                    .foregroundStyle(Color.kusiTextSecondary)
                    .fontDesign(.monospaced)
            }
            .padding(10)
            .background(Color.kusiBorder.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(Color.kusiSurface)
        .padding(.bottom, 20)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
