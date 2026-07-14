import SwiftUI

// MARK: - Banner reutilizable de Servicio Técnico / Repuestos
struct RepairServiceBanner: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    var body: some View {
        NavigationLink(destination: RepairCenterView()
            .environmentObject(themeManager)
        ) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(localizationManager.translate("home.repairTitle"))
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                    Text(localizationManager.translate("home.repairSubtitle"))
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray.opacity(0.4))
            }
            .padding(14)
            .background(Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
            }))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(themeManager.isDarkMode ? 0.25 : 0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
