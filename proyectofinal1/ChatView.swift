import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject private var store = ProductStore.shared  // fuente de productos para recomendaciones

    @State private var selectedColor: ColorOption?
    @State private var selectedStorage: StorageOption?
    @State private var quantity: Int = 1
    @State private var isFavorite: Bool = false
    @State private var showChat: Bool = false

    let product: Product
    var onAddToCart: ((Int, ColorOption?, StorageOption?) -> Void)?

    // MARK: - Productos relacionados (misma categoría)
    private var relatedProducts: [Product] {
        store.products.related(to: product)
    }

    // MARK: - Accesorios recomendados para este producto
    private var recommendedAccessories: [Product] {
        store.products.accessories(for: product)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Header con botón de Chat
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Atrás")
                            }
                            .foregroundColor(.blue)
                        }

                        Spacer()

                        Button(action: { showChat = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.left.fill")
                                Text("Chat")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(20)
                        }

                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // MARK: - Imagen del producto
                    // Usa RemoteOrLocalImage + finalImageURL para soportar tanto
                    // imágenes locales del catálogo como imágenes subidas a Firebase Storage.
                    RemoteOrLocalImage(source: product.finalImageURL, contentMode: .fit)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                        .padding(.horizontal)

                    // MARK: - Información del producto
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name)
                                    .font(.title2)
                                    .fontWeight(.bold)

                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                    Text("\(String(format: "%.1f", product.rating))")
                                        .font(.subheadline)
                                    Text("(\(product.reviewCount) reseñas)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                        }

                        // Stock Status
                        HStack {
                            Text(product.stockStatus)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(product.stockColor == "red" ? .red : (product.stockColor == "orange" ? .orange : .green))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(product.stockColor).opacity(0.1))
                                .cornerRadius(6)
                            Spacer()
                        }

                        // Precio
                        HStack(spacing: 8) {
                            if product.isOnSale {
                                Text("$\(String(format: "%.2f", product.discountedPrice))")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)

                                Text("$\(String(format: "%.2f", product.price))")
                                    .font(.body)
                                    .strikethrough()
                                    .foregroundColor(.secondary)

                                Text("-\(product.discount)%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            } else {
                                Text("$\(String(format: "%.2f", product.price))")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }

                        Divider()

                        // Descripción
                        Text("Descripción")
                            .font(.headline)

                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(5)
                    }
                    .padding(.horizontal)

                    // MARK: - Opciones de color
                    if !product.colorOptions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Colores disponibles")
                                .font(.headline)

                            HStack(spacing: 12) {
                                ForEach(product.colorOptions) { color in
                                    VStack {
                                        Circle()
                                            .fill(Color(hex: color.hexColor))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Circle()
                                                    .stroke(
                                                        selectedColor?.id == color.id ? Color.blue : Color.clear,
                                                        lineWidth: 3
                                                    )
                                            )

                                        Text(color.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Opciones de almacenamiento
                    if !product.storageOptions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Capacidad")
                                .font(.headline)

                            HStack(spacing: 8) {
                                ForEach(product.storageOptions) { storage in
                                    Button(action: { selectedStorage = storage }) {
                                        Text(storage.capacity)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                selectedStorage?.id == storage.id
                                                    ? Color.blue
                                                    : Color(.systemGray5)
                                            )
                                            .foregroundColor(
                                                selectedStorage?.id == storage.id ? .white : .black
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Productos relacionados / Recomendaciones
                    // (justo debajo de Capacidad, como indica RelatedProductsSection.swift)
                    relatedProductsSection(
                        title: "También te puede interesar",
                        products: relatedProducts
                    )
                    .environmentObject(themeManager)
                    .environmentObject(localizationManager)
                    .environmentObject(cartManager)

                    relatedProductsSection(
                        title: "Recomendado para ti",
                        products: recommendedAccessories
                    )
                    .environmentObject(themeManager)
                    .environmentObject(localizationManager)
                    .environmentObject(cartManager)

                    // MARK: - Cantidad
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cantidad")
                            .font(.headline)

                        HStack(spacing: 12) {
                            Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }

                            Text("\(quantity)")
                                .font(.headline)
                                .frame(maxWidth: .infinity)

                            Button(action: { quantity += 1 }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }

                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Botón Agregar al carrito
                    Button(action: {
                        // Llama directamente a CartManager: no dependemos de que cada
                        // pantalla que presenta ProductDetailView recuerde pasar onAddToCart.
                        cartManager.add(
                            product: product,
                            selectedColor: selectedColor?.name ?? (product.colorOptions.first?.name ?? "Único"),
                            selectedStorage: selectedStorage?.capacity ?? (product.storageOptions.first?.capacity ?? "Único"),
                            quantity: quantity
                        )
                        // Sigue notificando por si algún caller quiere reaccionar (opcional).
                        onAddToCart?(quantity, selectedColor, selectedStorage)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Agregar al carrito")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        // MARK: - Sheet del Chat de soporte
        .sheet(isPresented: $showChat) {
            SoporteView()
                .environmentObject(themeManager)
                .environmentObject(localizationManager)
        }
    }
}


