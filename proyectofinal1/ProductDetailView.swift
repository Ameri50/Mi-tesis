import SwiftUI

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
    @State private var selectedColor = ""
    @State private var selectedStorage = ""
    @State private var selectedRAM = ""
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

    private var categoryOptions: (colors: [String], storage: [String], ram: [String]) {
        switch product.category {
        case "iPhone":
            return (
                colors: ["Negro Medianoche", "Plata", "Oro", "Rojo (PRODUCT)", "Azul Claro"],
                storage: ["128GB", "256GB", "512GB", "1TB"],
                ram: []
            )
        case "iPad":
            return (
                colors: ["Gris Espacial", "Plata"],
                storage: ["64GB", "256GB", "512GB"],
                ram: []
            )
        case "Mac":
            return (
                colors: ["Plata", "Gris Espacial", "Oro", "Mediodía", "Medianoche"],
                storage: ["256GB", "512GB", "1TB", "2TB"],
                ram: ["8GB", "16GB", "32GB", "64GB"]
            )
        case "Apple Watch":
            return (
                colors: ["Aluminio Plata", "Aluminio Medianoche", "Aluminio Oro", "Acero Inoxidable", "Titanio"],
                storage: [],
                ram: []
            )
        case "AirPods":
            return (colors: ["Blanco"], storage: [], ram: [])
        default:
            return (colors: ["Estándar"], storage: [], ram: [])
        }
    }

    private var finalPrice: Double {
        var multiplier: Double = 1.0
        if !selectedStorage.isEmpty {
            switch selectedStorage {
            case "512GB": multiplier *= 1.15
            case "1TB":   multiplier *= 1.35
            case "2TB":   multiplier *= 1.65
            case "64GB":  multiplier *= 0.8
            default:      break
            }
        }
        if !selectedRAM.isEmpty {
            switch selectedRAM {
            case "16GB": multiplier *= 1.1
            case "32GB": multiplier *= 1.25
            case "64GB": multiplier *= 1.5
            default:     break
            }
        }
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

                        // Dot indicators
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

                            // Stars
                            HStack(spacing: 6) {
                                HStack(spacing: 2) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 11))
                                            .foregroundStyle(.orange)
                                    }
                                }
                                Text("4.8")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.orange)
                                Text("• 2.3K reseñas")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.gray)
                            }

                            // Price
                            HStack(alignment: .firstTextBaseline, spacing: 10) {
                                Text("$\(String(format: "%.2f", finalPrice))")
                                    .font(.system(size: fontSize + 14, weight: .bold))
                                    .foregroundStyle(.orange)

                                if finalPrice != product.price {
                                    Text("$\(String(format: "%.2f", product.price))")
                                        .font(.system(size: fontSize + 2))
                                        .foregroundStyle(.gray.opacity(0.6))
                                        .strikethrough()
                                }

                                Spacer()

                                // Availability badge
                                Text("En stock")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.green)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.green.opacity(0.12))
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

                        // MARK: - Color Selection
                        if !categoryOptions.colors.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Label("Color", systemImage: "paintpalette")
                                        .font(.system(size: fontSize + 1, weight: .semibold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Spacer()
                                    if !selectedColor.isEmpty {
                                        Text(selectedColor)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.orange)
                                    }
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 14) {
                                        ForEach(categoryOptions.colors, id: \.self) { color in
                                            VStack(spacing: 6) {
                                                Circle()
                                                    .fill(getColorForOption(color))
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

                                                Text(color.components(separatedBy: " ").first ?? color)
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

                        // MARK: - Storage Selection
                        if !categoryOptions.storage.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Label("Capacidad", systemImage: "internaldrive")
                                        .font(.system(size: fontSize + 1, weight: .semibold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Spacer()
                                    if !selectedStorage.isEmpty {
                                        Text(selectedStorage)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.orange)
                                    }
                                }

                                HStack(spacing: 10) {
                                    ForEach(categoryOptions.storage, id: \.self) { storage in
                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedStorage = storage
                                            }
                                        } label: {
                                            Text(storage)
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

                        // MARK: - RAM Selection
                        if !categoryOptions.ram.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Label("Memoria RAM", systemImage: "cpu")
                                        .font(.system(size: fontSize + 1, weight: .semibold))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Spacer()
                                    if !selectedRAM.isEmpty {
                                        Text(selectedRAM)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.orange)
                                    }
                                }

                                HStack(spacing: 10) {
                                    ForEach(categoryOptions.ram, id: \.self) { ram in
                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedRAM = ram
                                            }
                                        } label: {
                                            Text(ram)
                                                .font(.system(size: fontSize - 1.5, weight: .semibold))
                                                .foregroundStyle(selectedRAM == ram ? .white : (themeManager.isDarkMode ? .white : .black))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 11)
                                                .background(selectedRAM == ram ? Color.orange : Color.gray.opacity(0.12))
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
                            SpecBadge(icon: "shippingbox", label: "Envío gratis", theme: themeManager)
                            SpecBadge(icon: "arrow.uturn.left", label: "30 días devolución", theme: themeManager)
                            SpecBadge(icon: "checkmark.shield", label: "Garantía oficial", theme: themeManager)
                        }

                        // MARK: - Add to Cart Button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                cartManager.add(
                                    product: product,
                                    selectedColor: selectedColor.isEmpty ? "Estándar" : selectedColor,
                                    selectedStorage: selectedStorage.isEmpty ? "Estándar" : selectedStorage,
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
                        .disabled(isAddedToCart)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    // MARK: - Color helper
    private func getColorForOption(_ color: String) -> Color {
        switch color {
        case "Gris Espacial":       return Color(red: 0.5,  green: 0.5,  blue: 0.5)
        case "Plata":               return Color(red: 0.95, green: 0.95, blue: 0.97)
        case "Oro":                 return Color(red: 0.98, green: 0.87, blue: 0.66)
        case "Negro", "Negro Medianoche": return Color(red: 0.05, green: 0.05, blue: 0.1)
        case "Púrpura":             return Color(red: 0.7,  green: 0.6,  blue: 0.9)
        case "Rosa":                return Color(red: 0.95, green: 0.75, blue: 0.85)
        case "Blanco":              return Color(red: 0.98, green: 0.98, blue: 0.98)
        case "Rojo", "Rojo (PRODUCT)": return Color(red: 0.9, green: 0.2, blue: 0.2)
        case "Azul Claro":          return Color(red: 0.4,  green: 0.7,  blue: 0.95)
        case "Aluminio Plata":      return Color(red: 0.95, green: 0.95, blue: 0.97)
        case "Aluminio Medianoche": return Color(red: 0.05, green: 0.05, blue: 0.1)
        case "Aluminio Oro":        return Color(red: 0.98, green: 0.87, blue: 0.66)
        case "Acero Inoxidable":    return Color(red: 0.75, green: 0.75, blue: 0.78)
        case "Titanio":             return Color(red: 0.6,  green: 0.6,  blue: 0.65)
        case "Mediodía":            return Color(red: 0.98, green: 0.9,  blue: 0.6)
        default:                    return Color.gray
        }
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
