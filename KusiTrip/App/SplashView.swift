import SwiftUI

// Mirrors the UILaunchScreen in Kusi-Info.plist: same color asset, same logo at
// its natural point size, centered in the full screen. The first frame must be
// identical to the system launch screen so the hand-off is invisible.
struct SplashView: View {
    let isLeaving: Bool

    var body: some View {
        ZStack {
            Color(.launchBackground)
            Image(.launchLogo)
                .scaleEffect(isLeaving ? 1.12 : 1)
        }
        .ignoresSafeArea()
        .opacity(isLeaving ? 0 : 1)
    }
}

#Preview {
    SplashView(isLeaving: false)
}
