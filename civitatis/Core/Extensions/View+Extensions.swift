import SwiftUI

extension View {
    func civCard(cornerRadius: CGFloat = 12, shadow: Bool = true) -> some View {
        self
            .background(Color.civSurface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(shadow ? 0.08 : 0), radius: 4, x: 0, y: 2)
    }

    func onEventBus(perform action: @escaping @Sendable (AppEvent) async -> Void) -> some View {
        self.task {
            let stream = await EventBus.shared.subscribe()
            for await event in stream {
                await action(event)
            }
        }
    }
}
