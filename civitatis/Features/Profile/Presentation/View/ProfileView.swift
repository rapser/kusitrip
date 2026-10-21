import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(AppCoordinator.self) private var coordinator
    @State private var showLogoutAlert = false

    var body: some View {
        List {
            // Avatar header
            Section {
                HStack(spacing: 16) {
                    avatarView
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.currentUser?.fullName ?? "Viajero")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.kusiTextPrimary)
                        Text(viewModel.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundStyle(Color.kusiTextSecondary)
                        if let since = viewModel.currentUser?.memberSince {
                            Text("Miembro desde \(since)")
                                .font(.caption)
                                .foregroundStyle(Color.kusiTextSecondary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // Stats
            Section("Mis viajes") {
                statRow(icon: "heart.fill", color: Color.kusiDiscountRed,
                        title: "Favoritos", value: "Ver lista")
                statRow(icon: "ticket.fill", color: Color.kusiPrimary,
                        title: "Reservas", value: "Ver historial")
                statRow(icon: "star.fill", color: Color.kusiRatingGold,
                        title: "Mis valoraciones", value: "Ver todas")
            }

            // Settings
            Section("Ajustes") {
                settingsRow(icon: "person.circle", title: "Datos personales")
                settingsRow(icon: "bell", title: "Notificaciones")
                settingsRow(icon: "globe", title: "Idioma y región")
                settingsRow(icon: "lock.shield", title: "Privacidad y seguridad")
            }

            // Help
            Section("Ayuda") {
                settingsRow(icon: "questionmark.circle", title: "Centro de ayuda")
                settingsRow(icon: "phone", title: "Contactar Kusi Trip")
                settingsRow(icon: "doc.text", title: "Condiciones generales")
                settingsRow(icon: "hand.raised", title: "Política de privacidad")
            }

            // App info
            Section {
                HStack {
                    Label("Versión de la app", systemImage: "info.circle")
                        .foregroundStyle(Color.kusiTextSecondary)
                    Spacer()
                    Text("1.0.0")
                        .font(.footnote)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
                HStack {
                    Label("Valoración", systemImage: "star.circle")
                        .foregroundStyle(Color.kusiTextSecondary)
                    Spacer()
                    Text("9.1 / 10")
                        .font(.footnote)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
            }

            // Logout
            Section {
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.right.square")
                        Text("Cerrar sesión")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .background(Color.kusiBackground)
        .navigationTitle("Mi perfil")
        .navigationBarTitleDisplayMode(.large)
        .tint(Color.kusiPrimary)
        .onAppear { viewModel.setup(user: coordinator.currentUser) }
        .alert("¿Cerrar sesión?", isPresented: $showLogoutAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                Task { await viewModel.logout() }
            }
        } message: {
            Text("Se cerrará tu sesión en este dispositivo.")
        }
    }

    // MARK: - Avatar
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.kusiPrimary, Color.kusiAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(viewModel.currentUser?.initials ?? "?")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(.white)
        }
        .frame(width: 64, height: 64)
    }

    // MARK: - Helpers
    private func statRow(icon: String, color: Color, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(Color.kusiTextPrimary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(Color.kusiBorder)
        }
    }

    private func settingsRow(icon: String, title: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(Color.kusiTextPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(Color.kusiBorder)
        }
    }
}
