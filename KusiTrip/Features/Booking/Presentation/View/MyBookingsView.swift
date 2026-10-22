import SwiftUI

struct MyBookingsView: View {
    @State private var viewModel = MyBookingsViewModel()
    @State private var bookingToCancel: BookingConfirmationUI?

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.kusiTextPrimary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage, viewModel.bookings.isEmpty {
                ErrorStateView(message: error) { await viewModel.load() }
            } else if viewModel.bookings.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .background(Color.kusiBackground)
        .navigationTitle("Mis reservas")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .alert(
            "¿Cancelar la reserva?",
            isPresented: Binding(
                get: { bookingToCancel != nil },
                set: { if !$0 { bookingToCancel = nil } }
            ),
            presenting: bookingToCancel
        ) { booking in
            Button("Volver", role: .cancel) {}
            Button("Cancelar reserva", role: .destructive) {
                Task { await viewModel.cancel(booking) }
            }
        } message: { booking in
            Text(booking.activityTitle)
        }
    }

    private var list: some View {
        List(viewModel.bookings) { booking in
            BookingRow(booking: booking)
                .swipeActions {
                    if !booking.isCancelled && booking.isUpcoming {
                        Button("Cancelar", role: .destructive) {
                            bookingToCancel = booking
                        }
                    }
                }
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "ticket")
                .font(.system(size: 44))
                .foregroundStyle(Color.kusiTextSecondary)
            Text("Aún no tienes reservas")
                .font(.headline)
                .foregroundStyle(Color.kusiTextPrimary)
            Text("Cuando reserves una actividad aparecerá aquí.")
                .font(.subheadline)
                .foregroundStyle(Color.kusiTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct BookingRow: View {
    let booking: BookingConfirmationUI

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(url: booking.activityImageURL)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(booking.activityTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .lineLimit(2)
                Text("\(booking.formattedDate) · \(booking.formattedTime)")
                    .font(.caption)
                    .foregroundStyle(Color.kusiTextSecondary)
                HStack {
                    Text("\(booking.bookingId) · \(booking.numberOfPeopleText)")
                        .font(.caption2)
                        .foregroundStyle(Color.kusiTextSecondary)
                    Spacer()
                    Text(booking.isCancelled ? "Cancelada" : booking.formattedTotal)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(booking.isCancelled ? Color.kusiDiscountRed : Color.kusiTextPrimary)
                }
            }
        }
        .padding(.vertical, 4)
        .opacity(booking.isCancelled ? 0.6 : 1)
    }
}
