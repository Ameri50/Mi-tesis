import Foundation
import SwiftUI

// MARK: - CartItemModel (Con color y capacidad)
struct CartItemModel: Identifiable {
    let id: UUID
    var product: SeedProduct
    var quantity: Int
    var selectedColor: String
    var selectedStorage: String
    
    init(
        product: SeedProduct,
        quantity: Int = 1,
        selectedColor: String = "Gris Espacial",
        selectedStorage: String = "256GB"
    ) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
        self.selectedColor = selectedColor
        self.selectedStorage = selectedStorage
    }
    
    // Calcular precio final basado en capacidad
    var finalPrice: Double {
        let multiplier = product.storageOptions
            .first(where: { $0.capacity == selectedStorage })?
            .priceMultiplier ?? 1.0
        return product.price * multiplier
    }
    
    var totalPrice: Double {
        finalPrice * Double(quantity)
    }
    
    // Identificador único incluyendo color y capacidad
    var uniqueKey: String {
        "\(product.id)-\(selectedColor)-\(selectedStorage)"
    }
}

// MARK: - CartManager
class CartManager: ObservableObject {
    @Published var cartItems: [CartItemModel] = []
    
    var items: [CartItemModel] {
        return cartItems
    }
    
    // MARK: - Computed Properties
    
    var totalItemsCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var uniqueItemsCount: Int {
        cartItems.count
    }
    
    var totalPrice: Double {
        cartItems.reduce(0.0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        String(format: "$%.2f", totalPrice)
    }
    
    var isEmpty: Bool {
        cartItems.isEmpty
    }
    
    // MARK: - Public Methods
    
    func add(
        product: SeedProduct,
        selectedColor: String,
        selectedStorage: String,
        quantity: Int = 1
    ) {
        guard quantity > 0 else { return }
        
        // Buscar si existe el mismo producto con el mismo color y capacidad
        if let index = cartItems.firstIndex(where: { item in
            item.product.id == product.id &&
            item.selectedColor == selectedColor &&
            item.selectedStorage == selectedStorage
        }) {
            // Si existe, incrementar cantidad
            cartItems[index].quantity += quantity
        } else {
            // Si no existe, crear nuevo item
            let newItem = CartItemModel(
                product: product,
                quantity: quantity,
                selectedColor: selectedColor,
                selectedStorage: selectedStorage
            )
            cartItems.append(newItem)
        }
        
        objectWillChange.send()
        print("Agregado al carrito: \(product.name) - Color: \(selectedColor) - Capacidad: \(selectedStorage) x\(quantity)")
    }

    func add(item: CartItemModel) {
        guard item.quantity > 0 else { return }
        
        // Buscar por uniqueKey
        if let index = cartItems.firstIndex(where: { $0.uniqueKey == item.uniqueKey }) {
            cartItems[index].quantity += item.quantity
        } else {
            cartItems.append(item)
        }
        
        objectWillChange.send()
        print("Agregado al carrito: \(item.product.name) x\(item.quantity)")
    }

    func decrease(item: CartItemModel) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
                print("Cantidad reducida: \(item.product.name)")
            } else {
                remove(item: item)
            }
            objectWillChange.send()
        }
    }
    
    func increase(item: CartItemModel) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
            objectWillChange.send()
            print("Cantidad aumentada: \(item.product.name)")
        }
    }
    
    func updateQuantity(item: CartItemModel, quantity: Int) {
        guard quantity >= 0 else { return }
        
        if quantity == 0 {
            remove(item: item)
            return
        }
        
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = quantity
            objectWillChange.send()
            print("Cantidad actualizada: \(item.product.name) x\(quantity)")
        }
    }

    func remove(item: CartItemModel) {
        cartItems.removeAll { $0.id == item.id }
        objectWillChange.send()
        print("Eliminado del carrito: \(item.product.name)")
    }
    
    func remove(itemId: UUID) {
        cartItems.removeAll { $0.id == itemId }
        objectWillChange.send()
    }

    func clearCart() {
        cartItems.removeAll()
        objectWillChange.send()
        print("Carrito limpiado")
    }
    
    func contains(product: SeedProduct) -> Bool {
        cartItems.contains { $0.product.id == product.id }
    }
    
    func quantity(for product: SeedProduct) -> Int {
        cartItems.filter { $0.product.id == product.id }.reduce(0) { $0 + $1.quantity }
    }
    
    func getItem(for product: SeedProduct, color: String, storage: String) -> CartItemModel? {
        cartItems.first { item in
            item.product.id == product.id &&
            item.selectedColor == color &&
            item.selectedStorage == storage
        }
    }
    
    func getItems(for product: SeedProduct) -> [CartItemModel] {
        cartItems.filter { $0.product.id == product.id }
    }
    
    // MARK: - Validation
    
    func validateCart() {
        cartItems = cartItems.filter { $0.quantity > 0 }
    }
}

// MARK: - Preview Helper
extension CartManager {
    static func sample() -> CartManager {
        let manager = CartManager()
        return manager
    }
}
