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
            HStack(spacing: 16) {
                // Ícono en cuadrado redondeado, negro sólido / blanco sólido según modo
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(themeManager.isDarkMode ? Color.white : Color.black)
                        .frame(width: 52, height: 52)

                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .black : .white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(localizationManager.translate("home.repairTitle"))
                        .font(.system(size: fontSize + 1, weight: .bold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                    Text(localizationManager.translate("home.repairSubtitle"))
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundStyle(.gray)
                        .lineLimit(1)

                    // Badge sutil de confianza
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 9))
                        Text("Garantía incluida")
                            .font(.system(size: fontSize - 7, weight: .semibold))
                    }
                    .foregroundStyle(themeManager.isDarkMode ? .white.opacity(0.7) : .black.opacity(0.6))
                    .padding(.top, 2)
                }

                Spacer()

                // Flecha en cápsula
                ZStack {
                    Circle()
                        .fill(Color(UIColor { _ in
                            themeManager.isDarkMode ? UIColor(white: 0.22, alpha: 1) : UIColor(white: 0.94, alpha: 1)
                        }))
                        .frame(width: 30, height: 30)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(themeManager.isDarkMode ? .white.opacity(0.85) : .black.opacity(0.65))
                }
            }
            .padding(16)
            .background(
                Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.13, alpha: 1) : .white
                })
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        themeManager.isDarkMode ? Color.white.opacity(0.15) : Color.black.opacity(0.1),
                        lineWidth: 1.2
                    )
            )
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.06), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
