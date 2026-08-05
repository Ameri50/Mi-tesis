import SwiftUI

// NOTA: Este es un EJEMPLO de cómo integrar el Chat Support en tu ProductDetailView
// Reemplaza el código de tu DetailView actual con las secciones marcadas como "AGREGAR"

struct ProductDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedColor: ColorOption?
    @State private var selectedStorage: StorageOption?
    @State private var quantity: Int = 1
    @State private var isFavorite: Bool = false
    @State private var showChat: Bool = false  // ✅ AGREGAR ESTA LÍNEA
    
    let product: Product
    var onAddToCart: ((Int, ColorOption?, StorageOption?) -> Void)?
    
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
                        
                        // ✅ AGREGAR BOTÓN DE CHAT AQUÍ
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
                    VStack {
                        if !product.imageName.isEmpty {
                            Image(product.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(12)
                        } else {
                            Image(systemName: "photo")
                                .font(.system(size: 100))
                                .foregroundColor(.gray)
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                        }
                    }
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
        // ✅ AGREGAR SHEET PARA MOSTRAR EL CHAT
        .sheet(isPresented: $showChat) {
            ChatSupportView(
                product: product,
                onMessageSent: { message in
                    print("Mensaje enviado: \(message)")
                    // TODO: Aquí puedes guardar el mensaje en Firebase
                }
            )
        }
    }
}

// MARK: - Color extension para hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgb = Int(hex, radix: 16) ?? 0
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

