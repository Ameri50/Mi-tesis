import SwiftUI
import Foundation

// MARK: - Tarjeta de Producto con Imagen Estática
struct ProductImageCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let imageName: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor { _ in
                    themeManager.isDarkMode
                        ? UIColor(white: 0.1, alpha: 1)
                        : UIColor(white: 0.96, alpha: 1)
                }))

            if !imageName.isEmpty, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(24)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.system(size: 44))
                        .foregroundStyle(.orange.opacity(0.35))
                    Text("Sin imagen")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.7))
                }
            }
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - ProductDetailView
struct ProductDetailView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager

    let product: SeedProduct
    @EnvironmentObject var cartManager: CartManager
    @State private var isAddedToCart = false
    @State private var selectedColor: ColorOption? = nil
    @State private var selectedStorage: StorageOption? = nil
    @State private var currentImageIndex = 0

    private var bg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.07, alpha: 1)
                : UIColor(white: 0.97, alpha: 1)
        })
    }

    private var cardBg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.12, alpha: 1)
                : UIColor(white: 1.0, alpha: 1)
        })
    }

    private var allProductImages: [String] {
        var images = [product.imageName]
        images.append(contentsOf: product.additionalImages)
        return Array(images.prefix(5))
    }

    // Precio final usando storageOptions del propio SeedProduct
    private var finalPrice: Double {
        let multiplier = selectedStorage?.priceMultiplier ?? 1.0
        return product.price * multiplier
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Image Carousel
                    ZStack(alignment: .bottom) {
                        TabView(selection: $currentImageIndex) {
                            ForEach(allProductImages.indices, id: \.self) { index in
                                ProductImageCard(imageName: allProductImages[index])
                                    .environmentObject(themeManager)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 320)

                        if allProductImages.count > 1 {
                            HStack(spacing: 6) {
                                ForEach(allProductImages.indices, id: \.self) { i in
                                    Circle()
                                        .fill(i == currentImageIndex ? Color.orange : Color.gray.opacity(0.3))
                                        .frame(width: i == currentImageIndex ? 8 : 6,
                                               height: i == currentImageIndex ? 8 : 6)
                                        .animation(.spring(response: 0.3), value: currentImageIndex)
                                }
                            }
                            .padding(.bottom, 12)
                        }
                    }
                    .padding(.bottom, 8)

                    VStack(spacing: 16) {

                        // MARK: - Title & Price Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text(product.name)
                                .font(.system(size: fontSize + 10, weight: .bold))
                                .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                            HStack(spacing: 6) {
                                HStack(spacing: 2) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.orange)
                                    }
                                }
                                Text(String(format: "%.1f", product.rating))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.orange)
                                Text("• \(product.reviewCount) reseñas")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.gray)
                            }

                            HStack(alignment: .firstTextBaseline, spacing: 10) {
                                Text("S/ \(String(format: "%.2f", finalPrice))")
                                    .font(.system(size: fontSize + 14, weight: .bold))
                                    .foregroundStyle(.orange)

                                if finalPrice != product.price {
                                    Text("S/ \(String(format: "%.2f", product.price))")
                                        .font(.system(size: fontSize + 2))
                                        .foregroundStyle(.gray.opacity(0.6))
                                        .strikethrough()
                                }

                                Spacer()

                                Text(product.stockStatus)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(product.inStock ? .green : .red)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background((product.inStock ? Color.green : Color.red).opacity(0.12))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(20)
                        .background(cardBg)
                        .cornerRadius(20)

                        // MARK: - Description Card
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Descripción", systemImage: "text.alignleft")
                                .font(.system(size: fontSize + 1, weight: .semibold))
                                .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                            Text(product.productDescription)
                                .font(.system(size: fontSize - 1))
                                .foregroundStyle(themeManager.isDarkMode ? Color(white: 0.75) : .black.opacity(0.7))
                                .lineSpacing(5)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        .background(cardBg)
                        .cornerRadius(20)

                        // MARK: - Color Selection (directo de product.colorOptions)
                        if !product.colorOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Label("Color", systemImage: "paintpalette")
                                        .font(.system(size: fontSize + 1, weight: .semibold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Spacer()
                                    if let color = selectedColor {
                                        Text(color.name)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.orange)
                                    }
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 14) {
                                        ForEach(product.colorOptions) { color in
                                            VStack(spacing: 6) {
                                                Circle()
                                                    .fill(hexToColor(color.hexColor))
                                                    .frame(width: 44, height: 44)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(
                                                                selectedColor == color ? Color.orange : Color.gray.opacity(0.2),
                                                                lineWidth: selectedColor == color ? 3 : 1.5
                                                            )
                                                    )
                                                    .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                                                    .animation(.spring(response: 0.3), value: selectedColor)

                                                Text(color.name.components(separatedBy: " ").first ?? color.name)
                                                    .font(.system(size: 10, weight: .medium))
                                                    .foregroundStyle(.gray)
                                            }
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedColor = color
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 2)
                                }
                            }
                            .padding(20)
                            .background(cardBg)
                            .cornerRadius(20)
                        }

                        // MARK: - Storage Selection (directo de product.storageOptions)
                        if !product.storageOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Label("Capacidad", systemImage: "internaldrive")
                                        .font(.system(size: fontSize + 1, weight: .semibold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Spacer()
                                    if let storage = selectedStorage {
                                        Text(storage.capacity)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.orange)
                                    }
                                }

                                HStack(spacing: 10) {
                                    ForEach(product.storageOptions) { storage in
                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedStorage = storage
                                            }
                                        } label: {
                                            Text(storage.capacity)
                                                .font(.system(size: fontSize - 1.5, weight: .semibold))
                                                .foregroundStyle(selectedStorage == storage ? .white : (themeManager.isDarkMode ? .white : .black))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 11)
                                                .background(selectedStorage == storage ? Color.orange : Color.gray.opacity(0.12))
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            .padding(20)
                            .background(cardBg)
                            .cornerRadius(20)
                        }

                        // MARK: - Specs Row
                        HStack(spacing: 12) {
                            SpecBadge(icon: "shippingbox",      label: "Envío gratis",       theme: themeManager)
                            SpecBadge(icon: "arrow.uturn.left", label: "30 días devolución", theme: themeManager)
                            SpecBadge(icon: "checkmark.shield", label: "Garantía oficial",   theme: themeManager)
                        }

                        // MARK: - Add to Cart Button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                cartManager.add(
                                    product: product,
                                    selectedColor: selectedColor?.name ?? "Estándar",
                                    selectedStorage: selectedStorage?.capacity ?? "Estándar",
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
                                    .font(.system(size: 20, weight: .semibold))
                                Text(isAddedToCart ? "Agregado al carrito" : "Agregar al carrito")
                                    .font(.system(size: fontSize + 1, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(isAddedToCart ? Color.green : Color.orange)
                            .cornerRadius(16)
                        }
                        .disabled(isAddedToCart || !product.inStock)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        // ✅ .onAppear: inicializa selecciones con los primeros valores del propio producto
        .onAppear {
            selectedColor   = product.colorOptions.first
            selectedStorage = product.storageOptions.first
        }
    }

    // MARK: - Helper: hex string → SwiftUI Color
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

// MARK: - SpecBadge
struct SpecBadge: View {
    let icon: String
    let label: String
    let theme: ThemeManager

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.orange)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(UIColor { _ in
            theme.isDarkMode
                ? UIColor(white: 0.12, alpha: 1)
                : UIColor(white: 1.0, alpha: 1)
        }))
        .cornerRadius(16)
    }
}
