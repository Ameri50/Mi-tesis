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

// MARK: - Imagen de producto a pantalla completa (sin tarjeta gris)
struct ProductImageCard: View {
    @EnvironmentObject var themeManager: ThemeManager
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
                    Text("Sin imagen")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.7))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - ProductDetailView
struct ProductDetailView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    let product: Product  // ✅ Ahora usa Product (que era SeedProduct)
    @EnvironmentObject var cartManager: CartManager
    @State private var isAddedToCart = false
    @State private var selectedColor: ColorOption? = nil
    @State private var selectedStorage: StorageOption? = nil
    @State private var currentImageIndex = 0

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

    private var allProductImages: [String] {
        var images = [product.imageName]
        images.append(contentsOf: product.additionalImages)
        return Array(images.prefix(5))
    }

    // Precio final usando storageOptions del propio Product
    private var finalPrice: Double {
        let multiplier = selectedStorage?.priceMultiplier ?? 1.0
        return product.price * multiplier
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Hero: imagen a pantalla completa + botón atrás flotante
                    ZStack(alignment: .top) {
                        heroBg
                            .ignoresSafeArea(edges: .top)

                        VStack(spacing: 0) {
                            TabView(selection: $currentImageIndex) {
                                ForEach(allProductImages.indices, id: \.self) { index in
                                    ProductImageCard(imageName: allProductImages[index])
                                        .environmentObject(themeManager)
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 380)

                            if allProductImages.count > 1 {
                                HStack(spacing: 6) {
                                    ForEach(allProductImages.indices, id: \.self) { i in
                                        Capsule()
                                            .fill(i == currentImageIndex ? Color.orange : Color.gray.opacity(0.35))
                                            .frame(width: i == currentImageIndex ? 16 : 6, height: 6)
                                            .animation(.spring(response: 0.3), value: currentImageIndex)
                                    }
                                }
                                .padding(.bottom, 16)
                            }
                        }

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

                    // MARK: - Contenido superpuesto con esquinas redondeadas (efecto "sheet")
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

                                    RatingChip(rating: product.rating, reviewCount: product.reviewCount)
                                }
                                Spacer()
                                StatusBadge(text: product.stockStatus, isPositive: product.inStock)
                            }

                            PriceTag(
                                currentPrice: finalPrice,
                                originalPrice: finalPrice != product.price ? product.price : nil,
                                fontSize: fontSize
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.top, 4)

                        // MARK: - Descripción
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Descripción")
                                .font(.system(size: fontSize, weight: .semibold))
                                .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                            Text(product.description)  // ✅ Cambio: productDescription → description
                                .font(.system(size: fontSize - 1))
                                .foregroundStyle(themeManager.isDarkMode ? Color(white: 0.7) : .black.opacity(0.65))
                                .lineSpacing(5)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                        // MARK: - Color
                        if !product.colorOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Color")
                                        .font(.system(size: fontSize, weight: .semibold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Spacer()
                                    if let color = selectedColor {
                                        Text(color.name)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.orange)
                                            .adaptiveOneLine()
                                    }
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(product.colorOptions) { color in
                                            VStack(spacing: 6) {
                                                ZStack {
                                                    Circle()
                                                        .stroke(selectedColor == color ? Color.orange : Color.clear, lineWidth: 2)
                                                        .frame(width: 50, height: 50)

                                                    Circle()
                                                        .fill(hexToColor(color.hexColor))
                                                        .frame(width: 40, height: 40)
                                                        .overlay(
                                                            Circle().stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                                        )
                                                }
                                                .scaleEffect(selectedColor == color ? 1.06 : 1.0)
                                                .animation(.spring(response: 0.3), value: selectedColor)

                                                Text(color.name.components(separatedBy: " ").first ?? color.name)
                                                    .font(.system(size: 10, weight: .medium))
                                                    .foregroundStyle(.gray)
                                                    .adaptiveOneLine()
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
                            .padding(.horizontal, 20)
                        }

                        // MARK: - Capacidad (segmented pill)
                        if !product.storageOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Capacidad")
                                    .font(.system(size: fontSize, weight: .semibold))
                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                                HStack(spacing: 8) {
                                    ForEach(product.storageOptions) { storage in
                                        let isSelected = selectedStorage == storage
                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedStorage = storage
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

                        // MARK: - Specs Row
                        HStack(spacing: 10) {
                            SpecBadge(icon: "shippingbox",      label: "Envío gratis",       theme: themeManager)
                            SpecBadge(icon: "arrow.uturn.left", label: "30 días devolución", theme: themeManager)
                            SpecBadge(icon: "checkmark.shield", label: "Garantía oficial",   theme: themeManager)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                        // Espacio para que el contenido no quede tapado por la barra fija
                        Color.clear.frame(height: 90)
                    }
                    .padding(.bottom, 4)
                    .background(bg)
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                    .offset(y: -20)
                }
            }

            // MARK: - Barra de compra fija (sticky) abajo
            VStack(spacing: 0) {
                Divider().opacity(0.5)
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
            .background(.ultraThinMaterial)
            .ignoresSafeArea(edges: .bottom)
        }
        // ✅ .onAppear: inicializa selecciones con los primeros valores del propio producto
        .onAppear {
            selectedColor   = product.colorOptions.first
            selectedStorage = product.storageOptions.first
        }
        .navigationBarHidden(true)
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
                .font(.system(size: 18))
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
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.04), lineWidth: 1)
        )
    }
}
