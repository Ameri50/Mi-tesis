import SwiftUI

// MARK: - Category Chip (Componente Compartido - Versión Única)
struct CategoryChip: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let isSelected: Bool
    let fontSize: Double
    let isDarkMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize - 2, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : (isDarkMode ? .white : .black))
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(isSelected
                              ? Color.white.opacity(isDarkMode ? 0.28 : 0.35)
                              : Color.clear)
                )
                .appLiquidGlassSurface(
                    enabled: themeManager.isLiquidGlassEnabled,
                    darkMode: themeManager.isDarkMode,
                    cornerRadius: 999
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 12) {
        CategoryChip(
            title: "iPad",
            isSelected: true,
            fontSize: 16,
            isDarkMode: false,
            action: {}
        )
        
        CategoryChip(
            title: "iPhone",
            isSelected: false,
            fontSize: 16,
            isDarkMode: false,
            action: {}
        )
    }
    .padding()
}
