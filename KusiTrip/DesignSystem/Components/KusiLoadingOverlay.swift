import SwiftUI

/// Full-screen loader: blurred backdrop, the KusiTrip logo inside a spinning
/// brand-colored ring, and a message. Blocks touches while visible.
struct KusiLoadingOverlay: View {
    let message: String

    /// After this long a hint explains the wait. The API's free hosting can
    /// take up to a minute to answer the first request after being idle.
    private static let slowHintDelay: Duration = .seconds(6)
    private static let slowHint = "Está tardando más de lo habitual. Puede demorar hasta un minuto."

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isSpinning = false
    @State private var isPulsing = false
    @State private var showsSlowHint = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(Color.kusiTextPrimary.opacity(0.18))
                .ignoresSafeArea()

            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .stroke(Color.kusiPrimary.opacity(0.25), lineWidth: 5)

                    Circle()
                        .trim(from: 0, to: 0.72)
                        .stroke(
                            AngularGradient(
                                colors: [Color.kusiPrimary.opacity(0), Color.kusiPrimary, Color.kusiAccent],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 5, lineCap: .round)
                        )
                        .rotationEffect(.degrees(isSpinning ? 360 : 0))

                    Image(.launchLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.kusiTextPrimary.opacity(0.18), radius: 8, y: 4)
                        .scaleEffect(isPulsing ? 1.06 : 0.96)
                }
                .frame(width: 104, height: 104)

                VStack(spacing: 8) {
                    Text(message)
                        .font(.headline)
                        .foregroundStyle(Color.kusiTextPrimary)

                    if showsSlowHint {
                        Text(Self.slowHint)
                            .font(.footnote)
                            .foregroundStyle(Color.kusiTextSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: 240)
            }
            .padding(.horizontal, 36)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.kusiSurface)
                    .shadow(color: .black.opacity(0.12), radius: 24, y: 10)
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(showsSlowHint ? "\(message) \(Self.slowHint)" : message)
            .accessibilityAddTraits(.updatesFrequently)
        }
        .task {
            try? await Task.sleep(for: Self.slowHintDelay)
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.3)) { showsSlowHint = true }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                isSpinning = true
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

extension View {
    /// Covers the view with `KusiLoadingOverlay` while `isPresented` is true.
    /// Once shown it stays at least `minimumDuration`, so a fast operation
    /// does not flash the loader for a single frame.
    func kusiLoadingOverlay(
        isPresented: Bool,
        message: String,
        minimumDuration: Duration = .milliseconds(700)
    ) -> some View {
        modifier(KusiLoadingOverlayModifier(
            isPresented: isPresented,
            message: message,
            minimumDuration: minimumDuration
        ))
    }
}

private struct KusiLoadingOverlayModifier: ViewModifier {
    let isPresented: Bool
    let message: String
    let minimumDuration: Duration

    @State private var isVisible = false
    @State private var shownAt: ContinuousClock.Instant?

    func body(content: Content) -> some View {
        content
            .overlay {
                if isVisible {
                    KusiLoadingOverlay(message: message)
                        .transition(.opacity.combined(with: .scale(scale: 1.04)))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isVisible)
            .task(id: isPresented) {
                if isPresented {
                    shownAt = .now
                    isVisible = true
                } else if isVisible {
                    if let shownAt {
                        // Cancelled when isPresented turns true again: keep it visible.
                        do {
                            try await Task.sleep(until: shownAt.advanced(by: minimumDuration), clock: .continuous)
                        } catch {
                            return
                        }
                    }
                    isVisible = false
                }
            }
    }
}

#Preview {
    Color.kusiBackground
        .kusiLoadingOverlay(isPresented: true, message: "Iniciando sesión…")
}
