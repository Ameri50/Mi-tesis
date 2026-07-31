import SwiftUI

struct SupportHubView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
            })
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                header

                NavigationLink {
                    SoporteView()
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                } label: {
                    supportOptionCard(
                        icon: "message.fill",
                        title: localizationManager.translate("support.chat"),
                        subtitle: "Habla con el asistente tecnico para resolver dudas de reparaciones y repuestos.",
                        tint: .orange
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    SupportRecommendationsView()
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                        .environmentObject(cartManager)
                } label: {
                    supportOptionCard(
                        icon: "sparkles",
                        title: "Recomendaciones",
                        subtitle: "Explora sugerencias de productos segun lo que necesitas comprar.",
                        tint: .blue
                    )
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(16)
        }
        .navigationTitle(localizationManager.translate("support.title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(localizationManager.translate("support.heading"))
                .font(.system(size: fontSize + 3, weight: .bold))
                .foregroundColor(themeManager.isDarkMode ? .white : .primary)

            Text("Elige si quieres conversar con el chatbot tecnico o abrir recomendaciones rapidas de compra.")
                .font(.system(size: fontSize - 1))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.orange.opacity(themeManager.isDarkMode ? 0.22 : 0.14),
                    Color.blue.opacity(themeManager.isDarkMode ? 0.16 : 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func supportOptionCard(icon: String, title: String, subtitle: String, tint: Color) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.15))
                    .frame(width: 54, height: 54)

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(tint)
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

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
        }))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(themeManager.isDarkMode ? 0.2 : 0.06), radius: 4, x: 0, y: 2)
    }
}

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

    private let routes: [RecommendationRoute] = [
        RecommendationRoute(title: "Para estudiar", subtitle: "iPad y accesorios que rinden bien en clases y tareas.", category: "iPad", icon: "ipad.gen3", tint: .blue),
        RecommendationRoute(title: "Para trabajo", subtitle: "Mac y accesorios para productividad diaria.", category: "Mac", icon: "macbook", tint: .purple),
        RecommendationRoute(title: "Para uso diario", subtitle: "iPhone con buena relacion precio-rendimiento.", category: "iPhone", icon: "iphone.gen3", tint: .orange),
        RecommendationRoute(title: "Audio y movilidad", subtitle: "AirPods y opciones portatiles para el dia a dia.", category: "AirPods", icon: "airpodspro", tint: .green),
        RecommendationRoute(title: "Ver catalogo completo", subtitle: "Explora todas las categorias disponibles de la tienda.", category: "", icon: "square.grid.2x2.fill", tint: .pink)
    ]

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
            })
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header

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
                .padding(16)
            }
        }
        .navigationTitle("Recomendaciones")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            _ = store.products.count
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recomendaciones rapidas")
                .font(.system(size: fontSize + 3, weight: .bold))
                .foregroundColor(themeManager.isDarkMode ? .white : .primary)

            Text("Entrar aqui te lleva a categorias utiles para elegir el producto correcto segun el uso que le daras.")
                .font(.system(size: fontSize - 1))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(themeManager.isDarkMode ? 0.22 : 0.14),
                    Color.orange.opacity(themeManager.isDarkMode ? 0.16 : 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func recommendationCard(route: RecommendationRoute) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(route.tint.opacity(0.15))
                    .frame(width: 54, height: 54)

                Image(systemName: route.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(route.tint)
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

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
        }))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(themeManager.isDarkMode ? 0.2 : 0.06), radius: 4, x: 0, y: 2)
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
