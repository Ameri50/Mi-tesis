import SwiftUI

struct CategoryCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    let category: ProductCategory

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 90)

                Image(systemName: getCategoryIcon(for: category.title))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.orange)
            }

            VStack(spacing: 4) {
                Text(category.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("\(category.products.count) \(localizationManager.translate(category.products.count == 1 ? "category.product" : "category.products"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .appLiquidGlassSurface(
            enabled: themeManager.isLiquidGlassEnabled,
            darkMode: themeManager.isDarkMode,
            cornerRadius: 16
        )
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.12 : 0.06), radius: 4, x: 0, y: 2)
    }

    private func getCategoryIcon(for category: String) -> String {
        switch category {
        case "iPad":
            return "ipad"
        case "iPhone":
            return "iphone"
        case "Mac":
            return "macbook"
        case "Apple Watch":
            return "applewatch"
        case "Accesorios":
            return "bag"
        default:
            return "square.grid.2x2"
        }
    }
}

