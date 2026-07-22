import Foundation

// MARK: - Color Option (para opciones de color del producto)
struct ColorOption: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var hexColor: String
    
    enum CodingKeys: String, CodingKey {
        case name, hexColor
    }
    
    init(name: String, hexColor: String) {
        self.name = name
        self.hexColor = hexColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.hexColor = try container.decode(String.self, forKey: .hexColor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(hexColor, forKey: .hexColor)
    }
    
    static func == (lhs: ColorOption, rhs: ColorOption) -> Bool {
        lhs.name == rhs.name && lhs.hexColor == rhs.hexColor
    }
}

// MARK: - Storage Option (para opciones de almacenamiento)
struct StorageOption: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var capacity: String
    var priceMultiplier: Double
    
    enum CodingKeys: String, CodingKey {
        case capacity, priceMultiplier
    }
    
    init(capacity: String, priceMultiplier: Double) {
        self.capacity = capacity
        self.priceMultiplier = priceMultiplier
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.capacity = try container.decode(String.self, forKey: .capacity)
        self.priceMultiplier = try container.decode(Double.self, forKey: .priceMultiplier)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(capacity, forKey: .capacity)
        try container.encode(priceMultiplier, forKey: .priceMultiplier)
    }
    
    static func == (lhs: StorageOption, rhs: StorageOption) -> Bool {
        lhs.capacity == rhs.capacity && lhs.priceMultiplier == rhs.priceMultiplier
    }
}

// MARK: - Product Model (Sincronizado con Firestore)
struct Product: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var price: Double
    var category: String
    var image_url: String = ""
    var description: String = ""
    var stock: Int = 50
    var colorOptions: [ColorOption] = []
    var storageOptions: [StorageOption] = []
    
    // Campos para ProductDetailView
    var imageName: String = ""
    var additionalImages: [String] = []
    var rating: Double = 4.5
    var reviewCount: Int = 0
    var inStock: Bool = true
    
    // Campos legados (compatibilidad con datos viejos)
    var imageURL: String?
    
    // MARK: - Computed Properties
    /// Retorna la URL final de la imagen
    var finalImageURL: String {
        if !image_url.isEmpty {
            return image_url
        }
        return imageURL ?? imageName
    }
    
    /// Estado del stock para mostrar
    var stockStatus: String {
        inStock ? "En stock" : "Agotado"
    }
    
    /// Alias para compatibilidad con ProductDetailView que usa productDescription
    var productDescription: String {
        get { description }
        set { description = newValue }
    }
    
    // MARK: - Inicializador
    init(
        id: String = UUID().uuidString,
        name: String,
        price: Double,
        category: String,
        image_url: String = "",
        description: String = "",
        stock: Int = 50,
        colorOptions: [ColorOption] = [],
        storageOptions: [StorageOption] = [],
        imageName: String = "",
        additionalImages: [String] = [],
        rating: Double = 4.5,
        reviewCount: Int = 0,
        inStock: Bool = true,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.image_url = image_url
        self.description = description
        self.stock = stock
        self.colorOptions = colorOptions
        self.storageOptions = storageOptions
        self.imageName = imageName
        self.additionalImages = additionalImages
        self.rating = rating
        self.reviewCount = reviewCount
        self.inStock = inStock
        self.imageURL = imageURL
    }
}

// MARK: - SeedProduct (para compatibilidad con datos locales)
// Usa Product internamente pero con alias para que el código existente siga funcionando
typealias SeedProduct = Product
