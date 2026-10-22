import SwiftUI

struct SearchFieldView: View {
    let prompt: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.kusiTextSecondary)
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(prompt)
                        .foregroundStyle(Color.kusiTextSecondary)
                }
                TextField("", text: $text)
                    .foregroundStyle(Color.kusiTextPrimary)
                    .tint(Color.kusiTextPrimary)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
            }
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.kusiTextSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.kusiSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.kusiBorder))
    }
}

#Preview {
    SearchFieldView(prompt: "Buscar destinos o países", text: .constant(""))
        .padding()
}
