import SwiftUI

// MARK: - AdaptiveOneLine
// Evita que el texto se rompa en varias líneas cuando crece el tamaño de letra;
// en su lugar lo encoge hasta minScale para mantenerse en una sola línea.
struct AdaptiveOneLine: ViewModifier {
    var minScale: CGFloat = 0.6

    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .minimumScaleFactor(minScale)
    }
}

extension View {
    func adaptiveOneLine(minScale: CGFloat = 0.6) -> some View {
        modifier(AdaptiveOneLine(minScale: minScale))
    }
}

// MARK: - PriceTag
// Muestra precio actual + precio tachado (si hay descuento), en un layout
// que siempre se mantiene legible sin importar el tamaño de letra.
struct PriceTag: View {
    let currentPrice: Double
    var originalPrice: Double? = nil
    var fontSize: CGFloat = 16

    private var hasDiscount: Bool {
        guard let originalPrice else { return false }
        return originalPrice > currentPrice
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("S/ \(String(format: "%.2f", currentPrice))")
                .font(.system(size: fontSize + 14, weight: .bold))
                .foregroundStyle(.orange)
                .adaptiveOneLine()

            if hasDiscount, let originalPrice {
                Text("S/ \(String(format: "%.2f", originalPrice))")
                    .font(.system(size: fontSize + 2))
                    .foregroundStyle(.gray.opacity(0.6))
                    .strikethrough()
                    .adaptiveOneLine()
            }
        }

        if hasDiscount, let originalPrice {
            let percent = Int(((originalPrice - currentPrice) / originalPrice) * 100)
            Text("Ahorras \(percent)%")
                .font(.system(size: fontSize - 6, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.orange)
                .clipShape(Capsule())
        }
    }
}

// MARK: - StatusBadge
// Badge de estado reutilizable (En stock / Agotado / Disponible / etc.)
struct StatusBadge: View {
    let text: String
    let isPositive: Bool

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isPositive ? Color.green : Color.red)
                .frame(width: 6, height: 6)

            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .adaptiveOneLine()
        }
        .foregroundStyle(isPositive ? .green : .red)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background((isPositive ? Color.green : Color.red).opacity(0.12))
        .clipShape(Capsule())
    }
}

// MARK: - RatingChip
// Chip de estrellas + calificación + reseñas, con ajuste automático.
struct RatingChip: View {
    let rating: Double
    let reviewCount: Int

    var body: some View {
        HStack(spacing: 6) {
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { i in
                    Image(systemName: i < Int(rating.rounded()) ? "star.fill" : "star")
                        .font(.system(size: 11))
                        .foregroundStyle(.orange)
                }
            }
            Text(String(format: "%.1f", rating))
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.orange)
                .adaptiveOneLine()
            Text("• \(reviewCount) reseñas")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .adaptiveOneLine()
        }
    }
}

// MARK: - SectionCard
// Contenedor de tarjeta estándar (fondo, esquinas, sombra) para reemplazar
// bloques repetidos de .background(cardBg).cornerRadius(20) por toda la app.
struct SectionCard<Content: View>: View {
    @EnvironmentObject var themeManager: ThemeManager
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(
                Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.13, alpha: 1) : .white
                })
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        themeManager.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.25 : 0.05), radius: 8, x: 0, y: 3)
    }
}
