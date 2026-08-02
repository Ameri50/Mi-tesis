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
                .font(.system(size: fontSize - 2, weight: .medium))
                .foregroundColor(isSelected ? .white : (isDarkMode ? .white : .black))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .appLiquidGlassSurface(
                    enabled: themeManager.isLiquidGlassEnabled,
                    darkMode: themeManager.isDarkMode,
                    cornerRadius: 20
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(isSelected ? Color.white.opacity(0.55) : Color.clear, lineWidth: 1)
                )
        }
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
