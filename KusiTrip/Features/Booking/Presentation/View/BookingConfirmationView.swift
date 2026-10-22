import SwiftUI

struct BookingConfirmationView: View {
    let confirmation: BookingConfirmationUI
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                // Success icon
                ZStack {
                    Circle()
                        .fill(Color.kusiTextPrimary.opacity(0.10))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.kusiTextPrimary)
                }
                .padding(.top, 32)

                VStack(spacing: 8) {
                    Text("¡Reserva confirmada!")
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundStyle(Color.kusiTextPrimary)
                    Text("Te hemos enviado la confirmación por email.")
                        .font(.subheadline)
                        .foregroundStyle(Color.kusiTextSecondary)
                        .multilineTextAlignment(.center)
                }

                // Booking code
                VStack(spacing: 6) {
                    Text("Código de reserva")
                        .font(.caption)
                        .foregroundStyle(Color.kusiTextSecondary)
                    Text(confirmation.bookingId)
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.black)
                        .foregroundStyle(Color.kusiTextPrimary)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.kusiTextPrimary.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Summary card
                VStack(alignment: .leading, spacing: 14) {
                    Text("Resumen de tu reserva")
                        .font(.headline)
                        .foregroundStyle(Color.kusiTextPrimary)
                    Divider()
                    confirmRow(icon: "ticket", label: "Actividad", value: confirmation.activityTitle)
                    confirmRow(icon: "calendar", label: "Fecha", value: confirmation.formattedDate)
                    confirmRow(icon: "clock", label: "Hora", value: confirmation.formattedTime)
                    confirmRow(icon: "person.2", label: "Personas", value: confirmation.numberOfPeopleText)
                    Divider()
                    HStack {
                        Label("Total pagado", systemImage: "creditcard")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.kusiTextPrimary)
                        Spacer()
                        Text(confirmation.formattedTotal)
                            .font(.title3)
                            .fontWeight(.black)
                            .foregroundStyle(Color.kusiTextPrimary)
                    }
                }
                .padding(18)
                .kusiCard()

                Text("Confirmado el \(confirmation.confirmedAt)")
                    .font(.caption2)
                    .foregroundStyle(Color.kusiTextSecondary)

                // Actions
                VStack(spacing: 12) {
                    Button {
                        // Pop to root
                        dismiss()
                    } label: {
                        Label("Ir al inicio", systemImage: "house")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.kusiPrimary)
                            .foregroundStyle(Color.kusiTextPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    Button("Agregar a Favoritos") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.kusiTextPrimary)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.kusiBackground)
        .navigationTitle("Confirmación")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private func confirmRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextPrimary)
                .frame(width: 20)
            Text(label + ":")
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.kusiTextPrimary)
                .multilineTextAlignment(.trailing)
        }
    }
}
