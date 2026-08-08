import AppIntents
import SwiftUI
struct SupportRecommendationsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @ObservedObject private var store = ProductStore.shared

    private struct RecommendationRoute: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let category: String
        let icon: String
        let tint: Color
    }

    private var routes: [RecommendationRoute] {
        [
            RecommendationRoute(title: localizationManager.translate("support.study"), subtitle: localizationManager.translate("support.studySubtitle"), category: "iPad", icon: "ipad.gen3", tint: .blue),
            RecommendationRoute(title: localizationManager.translate("support.work"), subtitle: localizationManager.translate("support.workSubtitle"), category: "Mac", icon: "macbook", tint: .purple),
            RecommendationRoute(title: localizationManager.translate("support.dailyUse"), subtitle: localizationManager.translate("support.dailyUseSubtitle"), category: "iPhone", icon: "iphone.gen3", tint: .orange),
            RecommendationRoute(title: localizationManager.translate("support.audioMobility"), subtitle: localizationManager.translate("support.audioMobilitySubtitle"), category: "AirPods", icon: "airpodspro", tint: .green),
            RecommendationRoute(title: localizationManager.translate("support.fullCatalog"), subtitle: localizationManager.translate("support.fullCatalogSubtitle"), category: "", icon: "square.grid.2x2.fill", tint: .pink)
        ]
    }

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

                        sectionLabel(localizationManager.translate("support.exploreByCategory"))

                        VStack(spacing: 14) {
                            ForEach(routes) { route in
                                if route.category.isEmpty {
                                    NavigationLink {
                                        CategoryView()
                                            .environmentObject(cartManager)
                                            .environmentObject(themeManager)
                                            .environmentObject(localizationManager)
                                    } label: {
                                        recommendationCard(route: route)
                                    }
                                } else {
                                    NavigationLink {
                                        ProductListView(category: route.category)
                                            .environmentObject(themeManager)
                                            .environmentObject(cartManager)
                                            .environmentObject(localizationManager)
                                    } label: {
                                        recommendationCard(route: route)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .frame(minHeight: geo.size.height, alignment: .center)
                }
            }
        }
        .navigationTitle(localizationManager.translate("support.recommendations"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            _ = store.products.count
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: Color.blue.opacity(0.35), radius: 10, x: 0, y: 4)

                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(localizationManager.translate("support.quickRecommendations"))
                    .font(.system(size: fontSize + 5, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                Text(localizationManager.translate("support.quickRecommendationsSubtitle"))
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
                    Color.blue.opacity(themeManager.isDarkMode ? 0.24 : 0.16),
                    Color.purple.opacity(themeManager.isDarkMode ? 0.10 : 0.06),
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

    private func recommendationCard(route: RecommendationRoute) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(route.tint.gradient)
                    .frame(width: 52, height: 52)
                    .shadow(color: route.tint.opacity(0.35), radius: 8, x: 0, y: 3)

                Image(systemName: route.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(route.title)
                    .font(.system(size: fontSize + 1, weight: .semibold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                Text(route.subtitle)
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

#Preview("Soporte") {
    NavigationStack {
        SupportHubView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
            .environmentObject(CartManager())
    }
}
