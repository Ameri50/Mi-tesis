import SwiftUI

// MARK: - RelatedProductsSection
// Sección horizontal reutilizable de "Recomendaciones" / "También te puede interesar".
// Se usa en ProductDetailView (debajo de Capacidad) y en CartView (arriba del resumen de pago).
// Cada tarjeta navega directo al detalle del producto tocado.
struct RelatedProductsSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager

    let title: String
    let products: [Product]

    var body: some View {
        if !products.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(products) { relatedProduct in
                            NavigationLink {
                                ProductDetailView(product: relatedProduct)
                                    .environmentObject(themeManager)
                                    .environmentObject(cartManager)
                                    .environmentObject(localizationManager)
                            } label: {
                                RelatedProductCard(product: relatedProduct)
                                    .environmentObject(themeManager)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)
                }
            }
        }
    }
}

// MARK: - RelatedProductCard
private struct RelatedProductCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteOrLocalImage(source: product.finalImageURL, contentMode: .fit)
                .frame(width: 108, height: 108)
                .padding(8)
                .background(
                    themeManager.isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.03)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Text(product.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                .lineLimit(2)
                .frame(height: 34, alignment: .top)

            Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(themeManager.isDarkMode ? .orange : .accentColor)
        }
        .padding(10)
        .frame(width: 128)
        // ✅ El fondo (glass o sólido según el toggle de Ajustes) lo pone este único modifier,
        // así no queda un fondo opaco tapando el efecto liquid glass.
        .appLiquidGlassSurface(cornerRadius: 18)
    }
}

