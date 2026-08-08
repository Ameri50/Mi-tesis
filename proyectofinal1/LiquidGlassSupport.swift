import SwiftUI

// MARK: - Environment global para Liquid Glass
// Permite que CUALQUIER vista use `.appLiquidGlassSurface()` sin tener que
// pasar `themeManager.isLiquidGlassEnabled` / `themeManager.isDarkMode` a mano.
// Se inyecta una sola vez en proyectofinal1App.swift.
private struct LiquidGlassEnabledKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var liquidGlassEnabled: Bool {
        get { self[LiquidGlassEnabledKey.self] }
        set { self[LiquidGlassEnabledKey.self] = newValue }
    }
}

extension View {
    /// Nueva forma recomendada: toma el estado del Environment global.
    /// Úsala en vistas nuevas para que el toggle de Ajustes afecte
    /// automáticamente a toda la app, sin pasar parámetros.
    func appLiquidGlassSurface(cornerRadius: CGFloat = 16) -> some View {
        modifier(EnvironmentLiquidGlassSurfaceModifier(cornerRadius: cornerRadius))
    }

    /// Forma anterior, se mantiene por compatibilidad con las vistas
    /// que ya pasan `enabled`/`darkMode` explícitamente.
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

private struct EnvironmentLiquidGlassSurfaceModifier: ViewModifier {
    @Environment(\.liquidGlassEnabled) private var enabled
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.modifier(
            AppLiquidGlassSurfaceModifier(
                enabled: enabled,
                darkMode: colorScheme == .dark,
                cornerRadius: cornerRadius
            )
        )
    }
}

private struct AppLiquidGlassSurfaceModifier: ViewModifier {
    let enabled: Bool
    let darkMode: Bool
    let cornerRadius: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            if #available(iOS 26.0, *) {
                content
                    .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
                    .shadow(color: .black.opacity(darkMode ? 0.18 : 0.08), radius: 10, x: 0, y: 4)
            } else {
                content
                    .background(glassBackground)
                    .overlay(glassBorder)
                    .shadow(color: .black.opacity(darkMode ? 0.18 : 0.08), radius: 10, x: 0, y: 4)
            }
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
