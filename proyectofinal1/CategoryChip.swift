import SwiftUI

// MARK: - Category Chip (Componente Compartido - Versión Única)
struct CategoryChip: View {
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
                .background(
                    isSelected ?
                    LinearGradient(
                        gradient: Gradient(colors: [.black, .gray.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(UIColor { _ in
                                isDarkMode ? UIColor(white: 0.15, alpha: 1) : .secondarySystemBackground
                            }),
                            Color(UIColor { _ in
                                isDarkMode ? UIColor(white: 0.15, alpha: 1) : .secondarySystemBackground
                            })
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
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
