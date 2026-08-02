import SwiftUI

extension View {
    func appLiquidGlassSurface(
        enabled: Bool,
        darkMode: Bool,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(
            AppLiquidGlassSurfaceModifier(
                enabled: enabled,
                darkMode: darkMode,
                cornerRadius: cornerRadius
            )
        )
    }
}

private struct AppLiquidGlassSurfaceModifier: ViewModifier {
    let enabled: Bool
    let darkMode: Bool
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if enabled {
            content
                .background(glassBackground)
                .overlay(glassBorder)
                .shadow(color: .black.opacity(darkMode ? 0.18 : 0.08), radius: 10, x: 0, y: 4)
        } else {
            content
                .background(fallbackBackground)
        }
    }

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(darkMode ? 0.12 : 0.28),
                        Color.clear,
                        Color.blue.opacity(darkMode ? 0.06 : 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            )
    }

    private var glassBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(darkMode ? 0.24 : 0.45),
                        Color.white.opacity(0.06),
                        Color.blue.opacity(darkMode ? 0.12 : 0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }

    private var fallbackBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color(UIColor { _ in
                darkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
            }))
    }
}
