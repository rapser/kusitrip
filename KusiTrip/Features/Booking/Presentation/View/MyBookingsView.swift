import SwiftUI

struct MyBookingsView: View {
    @State private var viewModel = MyBookingsViewModel()
    @State private var bookingToCancel: BookingConfirmationUI?

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingSkeleton
                    .transition(.opacity)
            } else if let error = viewModel.errorMessage, viewModel.bookings.isEmpty {
                ErrorStateView(message: error) { await viewModel.load() }
                    .transition(.opacity)
            } else if viewModel.bookings.isEmpty {
                emptyState
                    .transition(.opacity)
            } else {
                list
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.isLoading)
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

    /// Rows with the shape of `BookingRow`, laid out like the plain List.
    private var loadingSkeleton: some View {
        // A ScrollView, like the List, so the rows start below the navigation bar.
        ScrollView {
            skeletonRows
        }
        .scrollDisabled(true)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando reservas")
    }

    private var skeletonRows: some View {
        VStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { _ in
                HStack(spacing: 12) {
                    SkeletonBlock(width: 72, height: 72, cornerRadius: 10)
                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonBlock(height: 13, cornerRadius: 5)
                        SkeletonBlock(width: 130, height: 10, cornerRadius: 4)
                        HStack {
                            SkeletonBlock(width: 110, height: 9, cornerRadius: 4)
                            Spacer()
                            SkeletonBlock(width: 60, height: 12, cornerRadius: 4)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                Divider().padding(.leading, 20)
            }
        }
        .kusiShimmer()
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
