import SwiftUI
import Foundation

// MARK: - Shape para redondear solo ciertas esquinas
struct RoundedCorner: Shape {
    var radius: CGFloat = 28
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Imagen de producto a pantalla completa
struct ProductImageCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    let imageName: String

    var body: some View {
        ZStack {
            if !imageName.isEmpty {
                RemoteOrLocalImage(source: imageName, contentMode: .fit)
                    .padding(36)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.system(size: 44))
                        .foregroundStyle(.orange.opacity(0.35))
                    Text(localizationManager.translate("product.noImage"))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.7))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Sección de recomendaciones mejorada con contexto
struct RelatedProductsSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager

    let title: String
    let subtitle: String?
    let products: [Product]
    let isPersonalized: Bool

    var body: some View {
        if !products.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                        
                        if isPersonalized {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.green)
                        }
                    }
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.gray)
                    }
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

// MARK: - Tarjeta de producto relacionado
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
        .appLiquidGlassSurface(cornerRadius: 18)
    }
}

// MARK: - ProductDetailView Principal
struct ProductDetailView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject private var store = ProductStore.shared
    @State private var isAddedToCart = false
    @State private var selectedColorIndex: Int? = nil
    @State private var selectedStorageIndex: Int? = nil

    private var bg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.05, alpha: 1)
                : UIColor(white: 0.97, alpha: 1)
        })
    }

    private var heroBg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.11, alpha: 1)
                : UIColor(white: 0.93, alpha: 1)
        })
    }

    private var cardBg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.12, alpha: 1)
                : UIColor(white: 1.0, alpha: 1)
        })
    }

    private var cardStroke: Color {
        themeManager.isDarkMode ? Color.white.opacity(0.07) : Color.black.opacity(0.05)
    }

    private var mainImageSource: String {
        if !product.finalImageURL.isEmpty {
            return product.finalImageURL
        }
        return product.imageName
    }

    private var finalPrice: Double {
        guard let selectedStorageIndex,
              product.storageOptions.indices.contains(selectedStorageIndex) else {
            return product.price
        }
        return product.price * product.storageOptions[selectedStorageIndex].priceMultiplier
    }

    private var selectedColorName: String {
        guard let selectedColorIndex,
              product.colorOptions.indices.contains(selectedColorIndex) else {
            return "Estándar"
        }
        return product.colorOptions[selectedColorIndex].name
    }

    private var selectedStorageCapacity: String {
        guard let selectedStorageIndex,
              product.storageOptions.indices.contains(selectedStorageIndex) else {
            return "Estándar"
        }
        return product.storageOptions[selectedStorageIndex].capacity
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Hero: imagen a pantalla completa + botón atrás
                    ZStack(alignment: .top) {
                        heroBg
                            .ignoresSafeArea(edges: .top)

                        ProductImageCard(imageName: mainImageSource)
                            .environmentObject(themeManager)
                            .environmentObject(localizationManager)
                            .frame(height: 380)

                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    .frame(width: 38, height: 38)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .frame(height: 380)

                    // MARK: - Contenido superpuesto con esquinas redondeadas
                    VStack(spacing: 14) {

                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 36, height: 4)
                            .padding(.top, 10)

                        // MARK: - Título, rating, precio
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(product.name)
                                        .font(.system(size: fontSize + 9, weight: .bold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                                    HStack(spacing: 6) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.orange)
                                        Text("\(String(format: "%.1f", product.rating)) (\(product.reviewCount) reviews)")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.gray)
                                    }
                                }
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(product.inStock ? "En stock" : "Agotado")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(product.inStock ? .green : .red)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(
                                            (product.inStock ? Color.green : Color.red).opacity(0.1)
                                        )
                                        .cornerRadius(6)
                                }
                            }

                            // Precio
                            HStack(spacing: 8) {
                                Text(finalPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.system(size: fontSize + 8, weight: .bold))
                                    .foregroundStyle(themeManager.isDarkMode ? .orange : .accentColor)

                                if finalPrice != product.price {
                                    Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .font(.system(size: fontSize - 2, weight: .medium))
                                        .foregroundStyle(.gray)
                                        .strikethrough()
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // MARK: - Descripción
                        if !product.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Descripción")
                                    .font(.system(size: fontSize, weight: .semibold))
                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                                Text(product.description)
                                    .font(.system(size: fontSize - 2, weight: .regular))
                                    .foregroundStyle(.gray)
                                    .lineSpacing(2)
                            }
                            .padding(.horizontal, 20)
                        }

                        // MARK: - Colores
                        if !product.colorOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Color")
                                    .font(.system(size: fontSize, weight: .semibold))
                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                                HStack(spacing: 12) {
                                    ForEach(product.colorOptions.indices, id: \.self) { index in
                                        let color = product.colorOptions[index]
                                        let isSelected = selectedColorIndex == index

                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedColorIndex = index
                                            }
                                        } label: {
                                            VStack(spacing: 8) {
                                                Circle()
                                                    .fill(hexToColor(color.hexColor))
                                                    .frame(width: 48, height: 48)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(
                                                                isSelected ? (themeManager.isDarkMode ? .white : .black) : .clear,
                                                                lineWidth: 2
                                                            )
                                                    )

                                                Text(color.name)
                                                    .font(.system(size: fontSize - 3, weight: .semibold))
                                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        // MARK: - Capacidad
                        if !product.storageOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Capacidad")
                                    .font(.system(size: fontSize, weight: .semibold))
                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                                HStack(spacing: 8) {
                                    ForEach(product.storageOptions.indices, id: \.self) { index in
                                        let storage = product.storageOptions[index]
                                        let isSelected = selectedStorageIndex == index

                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedStorageIndex = index
                                            }
                                        } label: {
                                            Text(storage.capacity)
                                                .font(.system(size: fontSize - 2, weight: .bold))
                                                .foregroundStyle(isSelected ? (themeManager.isDarkMode ? .black : .white) : (themeManager.isDarkMode ? .white : .black))
                                                .adaptiveOneLine(minScale: 0.7)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    isSelected
                                                        ? (themeManager.isDarkMode ? Color.white : Color.black)
                                                        : Color.gray.opacity(0.1)
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        // MARK: - Productos relacionados (sin personalización visible)
                        RelatedProductsSection(
                            title: "También te puede interesar",
                            subtitle: "Productos similares en stock",
                            products: store.products.related(to: product),
                            isPersonalized: false
                        )
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                        .environmentObject(cartManager)
                        .padding(.top, 8)

                        // MARK: - Accesorios recomendados (PERSONALIZADOS)
                        let accessories = store.products.accessories(for: product)
                        if !accessories.isEmpty {
                            RelatedProductsSection(
                                title: "Accesorios recomendados",
                                subtitle: "Compatibles con \(product.category)",
                                products: accessories,
                                isPersonalized: true
                            )
                            .environmentObject(themeManager)
                            .environmentObject(localizationManager)
                            .environmentObject(cartManager)
                            .padding(.top, 8)
                        }

                        // MARK: - Specs
                        HStack(spacing: 10) {
                            VStack(spacing: 6) {
                                Image(systemName: "shippingbox")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.orange)
                                Text("Envío gratis")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .appLiquidGlassSurface(
                                enabled: themeManager.isLiquidGlassEnabled,
                                darkMode: themeManager.isDarkMode,
                                cornerRadius: 14
                            )

                            VStack(spacing: 6) {
                                Image(systemName: "arrow.uturn.left")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.orange)
                                Text("30 días retorno")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .appLiquidGlassSurface(
                                enabled: themeManager.isLiquidGlassEnabled,
                                darkMode: themeManager.isDarkMode,
                                cornerRadius: 14
                            )

                            VStack(spacing: 6) {
                                Image(systemName: "checkmark.shield")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.orange)
                                Text("Garantía oficial")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .appLiquidGlassSurface(
                                enabled: themeManager.isLiquidGlassEnabled,
                                darkMode: themeManager.isDarkMode,
                                cornerRadius: 14
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                        Color.clear.frame(height: 90)
                    }
                    .padding(.bottom, 4)
                    .appLiquidGlassSurface(
                        enabled: themeManager.isLiquidGlassEnabled,
                        darkMode: themeManager.isDarkMode,
                        cornerRadius: 28
                    )
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                    .offset(y: -20)
                }
            }

            // MARK: - Barra de compra fija
            VStack(spacing: 0) {
                Divider().opacity(0.5)
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        cartManager.add(
                            product: product,
                            selectedColor: selectedColorName,
                            selectedStorage: selectedStorageCapacity,
                            quantity: 1
                        )
                        isAddedToCart = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation { isAddedToCart = false }
                        }
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: isAddedToCart ? "checkmark.circle.fill" : "cart.badge.plus")
                            .font(.system(size: 19, weight: .semibold))
                        Text(isAddedToCart ? "Agregado al carrito" : "Agregar al carrito")
                            .font(.system(size: fontSize + 1, weight: .bold))
                            .adaptiveOneLine(minScale: 0.7)
                    }
                    .foregroundStyle(isAddedToCart ? .white : (themeManager.isDarkMode ? .black : .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isAddedToCart ? Color.green : (themeManager.isDarkMode ? Color.white : Color.black))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(isAddedToCart || !product.inStock)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
            }
            .appLiquidGlassSurface(
                enabled: themeManager.isLiquidGlassEnabled,
                darkMode: themeManager.isDarkMode,
                cornerRadius: 22
            )
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            selectedColorIndex = product.colorOptions.isEmpty ? nil : 0
            selectedStorageIndex = product.storageOptions.isEmpty ? nil : 0
        }
        .navigationBarHidden(true)
    }

    private func hexToColor(_ hex: String) -> Color {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >>  8) & 0xFF) / 255
        let b = Double( int        & 0xFF) / 255
        return Color(red: r, green: g, blue: b)
    }
}
