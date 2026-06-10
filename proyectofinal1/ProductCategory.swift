import Foundation

struct ProductCategory: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let products: [Product]
    let icon: String?
    let description: String?
    
    init(id: UUID = UUID(), title: String, products: [Product], icon: String? = nil, description: String? = nil) {
        self.id = id
        self.title = title
        self.products = products
        self.icon = icon
        self.description = description
    }
    
    // MARK: - Hashable
    /// Genera un valor hash único basado en el ID
    /// Esto permite que ProductCategory se use en Sets y como claves en Dictionaries
    /// El hash se combina solo con el ID para asegurar que categorías diferentes tienen hashes diferentes
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  // Añade el ID al hasher
    }
    
    // MARK: - Equatable
    /// Compara dos ProductCategory por su ID
    /// Dos categorías son iguales si tienen el mismo ID
    /// - Parameters:
    ///   - lhs: ProductCategory izquierdo (Left Hand Side)
    ///   - rhs: ProductCategory derecho (Right Hand Side)
    /// - Returns: true si ambas tienen el mismo ID, false en caso contrario
    static func == (lhs: ProductCategory, rhs: ProductCategory) -> Bool {
        lhs.id == rhs.id
    }
}
