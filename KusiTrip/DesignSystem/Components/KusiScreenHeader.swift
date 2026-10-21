import SwiftUI

struct KusiScreenHeader<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.kusiTextPrimary)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(Color.kusiPrimary)
    }
}

extension KusiScreenHeader where Content == EmptyView {
    init(title: String) {
        self.init(title: title) { EmptyView() }
    }
}

#Preview {
    VStack(spacing: 0) {
        KusiScreenHeader(title: "Destinos") {
            SearchFieldView(prompt: "Buscar destinos o países", text: .constant(""))
        }
        Spacer()
    }
}
