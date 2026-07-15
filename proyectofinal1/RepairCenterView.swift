import SwiftUI

struct RepairCenterView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    @State private var selectedCategory: String = "iPhone"
    @State private var selectedModel: String = "iPhone 12"

    var modelsForCategory: [String] {
        RepairData.modelsByCategory[selectedCategory] ?? []
    }

    var filteredParts: [RepairPart] {
        RepairData.parts.filter { $0.compatibleModels.contains(selectedModel) }
    }

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            })
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    headerSection
                    categorySelectorSection
                    modelSelectorSection
                    partsSection
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("Servicio Técnico Apple")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Repuestos y Reparaciones")
                .font(.system(size: fontSize + 4, weight: .bold))
                .foregroundStyle(themeManager.isDarkMode ? .white : .black)

            Text("Repuestos originales con garantía e instalación profesional.")
                .font(.system(size: fontSize - 2))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }

    // MARK: - Category selector

    private var categorySelectorSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Categoría")
                .font(.system(size: fontSize - 1, weight: .semibold))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(RepairData.categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category,
                            fontSize: fontSize,
                            isDarkMode: themeManager.isDarkMode,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = category
                                    selectedModel = RepairData.modelsByCategory[category]?.first ?? ""
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Model selector

    private var modelSelectorSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Modelo")
                .font(.system(size: fontSize - 1, weight: .semibold))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(modelsForCategory, id: \.self) { model in
                        CategoryChip(
                            title: model,
                            isSelected: selectedModel == model,
                            fontSize: fontSize,
                            isDarkMode: themeManager.isDarkMode,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedModel = model
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Parts list

    private var partsSection: some View {
        VStack(spacing: 12) {
            if filteredParts.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "wrench.and.screwdriver")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.4))
                    Text("Sin repuestos disponibles para este modelo.")
                        .font(.system(size: fontSize - 2))
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 40)
            } else {
                ForEach(filteredParts) { part in
                    NavigationLink(destination:
                        RepairDetailView(part: part)
                            .environmentObject(themeManager)
                    ) {
                        RepairPartCardView(part: part)
                            .environmentObject(themeManager)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.bottom, 16)
    }
}

// MARK: - RepairPartCardView

struct RepairPartCardView: View {
    let part: RepairPart
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor { _ in
                        themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : UIColor(white: 0.95, alpha: 1)
                    }))
                    .frame(width: 70, height: 70)

                Image(systemName: part.icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(part.name)
                    .font(.system(size: fontSize - 1, weight: .semibold))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    .lineLimit(2)

                Text(part.description)
                    .font(.system(size: fontSize - 5))
                    .foregroundStyle(.gray)
                    .lineLimit(2)

                HStack(spacing: 10) {
                    Text(String(format: "S/ %.2f", part.price))
                        .font(.system(size: fontSize - 2, weight: .bold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                        .adaptiveOneLine()

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(part.repairTime)
                            .font(.system(size: fontSize - 5))
                            .adaptiveOneLine()
                    }
                    .foregroundStyle(.gray)
                }

                StatusBadge(text: part.stock ? "Disponible" : "Agotado", isPositive: part.stock)
            }

            Spacer()
        }
        .padding(14)
        .frame(minHeight: 100)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
        }))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(themeManager.isDarkMode ? 0.2 : 0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
    }

}

#Preview {
    NavigationStack {
        RepairCenterView()
            .environmentObject(ThemeManager())
    }
}
