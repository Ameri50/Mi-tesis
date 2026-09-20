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
        if cornerRadius <= 0 {
            // Fondo de pantalla completo: superficie base plana, sin cajas.
            content.background(baseBackground)
        } else {
            // Tarjeta moderna: relleno elevado continuo + hairline sutil + sombra suave.
            content
                .background(cardFill)
                .overlay(cardBorder)
                .shadow(color: .black.opacity(darkMode ? 0.16 : 0.05), radius: 12, x: 0, y: 4)
        }
    }

    private var baseBackground: some View {
        LinearGradient(
            colors: [
                Color(UIColor { _ in darkMode ? UIColor(white: 0.09, alpha: 1) : UIColor.systemGroupedBackground }),
                Color(UIColor { _ in darkMode ? UIColor(white: 0.05, alpha: 1) : UIColor.secondarySystemGroupedBackground })
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var cardFill: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color(UIColor { _ in
                darkMode ? UIColor(white: 0.13, alpha: 1) : UIColor.secondarySystemGroupedBackground
            }))
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(Color.primary.opacity(darkMode ? 0.08 : 0.05), lineWidth: 1)
    }
}
