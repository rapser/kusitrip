import SwiftUI

struct BookingView: View {
    let activityId: String
    @State private var viewModel = BookingViewModel()
    @State private var showConfirmation = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                activityHeader
                formSection
                summarySection
            }
        }
        .background(Color.civBackground)
        .navigationTitle("Reservar")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.loadActivity(id: activityId) }
        .navigationDestination(isPresented: $showConfirmation) {
            if let confirmation = viewModel.confirmation {
                BookingConfirmationView(confirmation: confirmation)
            }
        }
    }

    // MARK: - Activity header
    private var activityHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "ticket.fill")
                .font(.title2)
                .foregroundStyle(Color.civPrimary)
                .frame(width: 48, height: 48)
                .background(Color.civPrimary.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.activityTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextPrimary)
                    .lineLimit(2)
                Label("Cancelación gratuita", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(Color.civPrimary)
            }
        }
        .padding(16)
        .background(Color.civSurface)
    }

    // MARK: - Form
    private var formSection: some View {
        VStack(spacing: 0) {
            // Date picker
            VStack(alignment: .leading, spacing: 8) {
                Label("Fecha de la actividad", systemImage: "calendar")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextPrimary)
                DatePicker(
                    "",
                    selection: $viewModel.selectedDate,
                    in: viewModel.minimumDate...viewModel.maximumDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color.civPrimary)
            }
            .padding(16)
            .background(Color.civSurface)
            .padding(.top, 12)

            // Time picker
            VStack(alignment: .leading, spacing: 8) {
                Label("Hora", systemImage: "clock")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextPrimary)
                DatePicker(
                    "",
                    selection: $viewModel.selectedDate,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .frame(height: 100)
                .tint(Color.civPrimary)
            }
            .padding(16)
            .background(Color.civSurface)
            .padding(.top, 8)

            // People picker
            VStack(alignment: .leading, spacing: 12) {
                Label("Número de personas", systemImage: "person.2")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.civTextPrimary)
                HStack {
                    Text("\(viewModel.numberOfPeople) persona\(viewModel.numberOfPeople > 1 ? "s" : "")")
                        .font(.body)
                        .foregroundStyle(Color.civTextPrimary)
                    Spacer()
                    Stepper(
                        "",
                        value: $viewModel.numberOfPeople,
                        in: 1...20
                    )
                    .labelsHidden()
                    .tint(Color.civPrimary)
                }
            }
            .padding(16)
            .background(Color.civSurface)
            .padding(.top, 8)
        }
    }

    // MARK: - Summary + CTA
    private var summarySection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                summaryRow(label: "Precio por persona",
                           value: "S/ \(String(format: "%.2f", viewModel.pricePerPerson))")
                summaryRow(label: "Personas",
                           value: "\(viewModel.numberOfPeople)")
                Divider()
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.civTextPrimary)
                    Spacer()
                    Text(viewModel.formattedTotal)
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundStyle(Color.civPrimary)
                }
            }
            .padding(16)
            .civCard()

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(Color.civDiscountRed)
                    .padding(10)
                    .background(Color.civDiscountRed.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            PrimaryButton(title: "Confirmar reserva", isLoading: viewModel.isLoading) {
                await viewModel.confirm()
                if viewModel.confirmation != nil {
                    showConfirmation = true
                }
            }
        }
        .padding(16)
        .padding(.bottom, 24)
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.civTextSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.civTextPrimary)
        }
    }
}
