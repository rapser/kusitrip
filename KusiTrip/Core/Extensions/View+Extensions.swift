import SwiftUI

extension View {
    func kusiCard(cornerRadius: CGFloat = 12, shadow: Bool = true) -> some View {
        self
            .background(Color.kusiSurface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(shadow ? 0.08 : 0), radius: 4, x: 0, y: 2)
    }

    /// Disables the rubber-band overscroll of the enclosing ScrollView.
    /// Apply it to the ScrollView's content, not to the ScrollView itself.
    func scrollBounceDisabled() -> some View {
        background(ScrollBounceDisabler())
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

// SwiftUI's scrollBounceBehavior only stops bouncing when content fits on screen,
// so the backing UIScrollView is configured directly.
private struct ScrollBounceDisabler: UIViewRepresentable {
    func makeUIView(context: Context) -> FinderView { FinderView() }
    func updateUIView(_ uiView: FinderView, context: Context) {}

    final class FinderView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            var view = superview
            while let current = view, !(current is UIScrollView) {
                view = current.superview
            }
            guard let scrollView = view as? UIScrollView else { return }
            scrollView.bounces = false
        }
    }
}
