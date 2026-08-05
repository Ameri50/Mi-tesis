import SwiftUI

// MARK: - RelatedProductsSection
// Sección horizontal reutilizable de "Recomendaciones" / "También te puede interesar".
// Se usa en ProductDetailView (debajo de Capacidad) y en CartView (arriba del resumen de pago).
// Cada tarjeta navega directo al detalle del producto tocado.
//
// `accessory` es un view builder opcional que se muestra a la derecha del título
// (por ejemplo, el botón de "expandir carrito" en CartView). Si no se pasa nada,
// no aparece ningún accesorio y el comportamiento es idéntico al de antes.
struct relatedProductsSection<Accessory: View>: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager

    let title: String
    let products: [Product]
    @ViewBuilder var accessory: () -> Accessory

    var body: some View {
        if !products.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                    Spacer()

                    accessory()
                }
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

// Permite seguir llamando `relatedProductsSection(title:products:)` sin accesorio,
// tal como ya se usa en ProductDetailView, sin tener que tocar esas llamadas.
extension relatedProductsSection where Accessory == EmptyView {
    init(title: String, products: [Product]) {
        self.title = title
        self.products = products
        self.accessory = { EmptyView() }
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
