import SwiftUI

// MARK: - Estilo de presión reutilizable
private struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.32, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct SupportHubView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.09, alpha: 1) : .systemGroupedBackground
            })
            .ignoresSafeArea()

            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        header

                        sectionLabel(localizationManager.translate("support.helpSection"))

                        VStack(spacing: 14) {
                            NavigationLink {
                                SoporteView()
                                    .environmentObject(themeManager)
                                    .environmentObject(localizationManager)
                            } label: {
                                supportOptionCard(
                                    icon: "message.fill",
                                    title: localizationManager.translate("support.chat"),
                                    subtitle: localizationManager.translate("support.chatSubtitle"),
                                    gradient: [Color.orange, Color.pink]
                                )
                            }
                            .buttonStyle(PressableCardStyle())

                            NavigationLink {
                                SupportRecommendationsView()
                                    .environmentObject(themeManager)
                                    .environmentObject(localizationManager)
                                    .environmentObject(cartManager)
                            } label: {
                                supportOptionCard(
                                    icon: "sparkles",
                                    title: localizationManager.translate("support.recommendations"),
                                    subtitle: localizationManager.translate("support.recommendationsSubtitle"),
                                    gradient: [Color.blue, Color.purple]
                                )
                            }
                            .buttonStyle(PressableCardStyle())
                        }
                    }
                    .padding(16)
                    .frame(minHeight: geo.size.height, alignment: .center)
                }
            }
        }
        .navigationTitle(localizationManager.translate("support.title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: Color.orange.opacity(0.35), radius: 10, x: 0, y: 4)

                Image(systemName: "questionmark.bubble.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(localizationManager.translate("support.heading"))
                    .font(.system(size: fontSize + 5, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                Text(localizationManager.translate("support.hubSubtitle"))
                    .font(.system(size: fontSize - 1))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.orange.opacity(themeManager.isDarkMode ? 0.24 : 0.16),
                    Color.pink.opacity(themeManager.isDarkMode ? 0.10 : 0.06),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(themeManager.isDarkMode ? 0.08 : 0.5), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .tracking(0.8)
            .foregroundColor(.secondary)
            .padding(.leading, 4)
    }

    private func supportOptionCard(icon: String, title: String, subtitle: String, gradient: [Color]) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: gradient[0].opacity(0.35), radius: 8, x: 0, y: 3)

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: fontSize + 1, weight: .semibold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                Text(subtitle)
                    .font(.system(size: fontSize - 3))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            ZStack {
                Circle()
                    .fill(Color.secondary.opacity(themeManager.isDarkMode ? 0.15 : 0.08))
                    .frame(width: 28, height: 28)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .appLiquidGlassSurface(
            enabled: themeManager.isLiquidGlassEnabled,
            darkMode: themeManager.isDarkMode,
            cornerRadius: 20
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(themeManager.isDarkMode ? 0.06 : 0.5), lineWidth: themeManager.isLiquidGlassEnabled ? 0 : 1)
        )
        .shadow(color: .black.opacity(themeManager.isDarkMode ? 0.25 : 0.06), radius: 10, x: 0, y: 5)
    }
}
