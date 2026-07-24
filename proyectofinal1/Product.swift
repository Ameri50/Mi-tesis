import Foundation

// MARK: - Color Option (para opciones de color del producto)
struct ColorOption: Identifiable, Codable, Equatable, Hashable {
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
struct StorageOption: Identifiable, Codable, Equatable, Hashable {
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
struct Product: Identifiable, Codable, Hashable {
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

    // Campos legados
    var imageURL: String?
    var isOnSale: Bool = false
    var discount: Int = 0
    var specs: String = ""
    var reviews: [String] = []
    var weight: Double = 0
    var dimensions: String = ""
    var color: String = ""
    var suggestedDevices: [String] = []

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
        if !inStock { return "Agotado" }
        if stock <= 5 { return "Ultimas unidades" }
        if stock <= 10 { return "Stock bajo" }
        return "En stock"
    }

    var stockColor: String {
        if !inStock { return "red" }
        if stock <= 5 { return "orange" }
        return "green"
    }

    var discountedPrice: Double {
        guard isOnSale && discount > 0 else { return price }
        return price - (price * Double(discount) / 100)
    }

    /// Alias para compatibilidad con ProductDetailView que usa productDescription
    var productDescription: String {
        get { description }
        set { description = newValue }
    }

    // MARK: - Inicializador principal
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
        imageURL: String? = nil,
        isOnSale: Bool = false,
        discount: Int = 0,
        specs: String = "",
        reviews: [String] = [],
        weight: Double = 0,
        dimensions: String = "",
        color: String = "",
        suggestedDevices: [String] = []
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
        self.isOnSale = isOnSale
        self.discount = discount
        self.specs = specs
        self.reviews = reviews
        self.weight = weight
        self.dimensions = dimensions
        self.color = color
        self.suggestedDevices = suggestedDevices
    }

    // MARK: - Inicializadores de compatibilidad
    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        category: String,
        imageName: String,
        additionalImages: [String],
        productDescription: String,
        colorOptions: [ColorOption] = [],
        storageOptions: [StorageOption] = [],
        stock: Int = 50,
        rating: Double = 4.5,
        reviewCount: Int = 0,
        isOnSale: Bool = false,
        discount: Int = 0,
        inStock: Bool = true
    ) {
        self.init(
            id: id.uuidString,
            name: name,
            price: price,
            category: category,
            description: productDescription,
            stock: stock,
            colorOptions: colorOptions,
            storageOptions: storageOptions,
            imageName: imageName,
            additionalImages: additionalImages,
            rating: rating,
            reviewCount: reviewCount,
            inStock: inStock,
            isOnSale: isOnSale,
            discount: discount
        )
    }

    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        imageName: String,
        category: String,
        specs: String,
        reviews: [String],
        weight: Double,
        dimensions: String,
        color: String,
        suggestedDevices: [String],
        additionalImages: [String]?,
        description: String
    ) {
        self.init(
            id: id.uuidString,
            name: name,
            price: price,
            category: category,
            description: description,
            imageName: imageName,
            additionalImages: additionalImages ?? [],
            specs: specs,
            reviews: reviews,
            weight: weight,
            dimensions: dimensions,
            color: color,
            suggestedDevices: suggestedDevices
        )
    }
}

// MARK: - SeedProduct (para compatibilidad con datos locales)
// Usa Product internamente pero con alias para que el codigo existente siga funcionando.
typealias SeedProduct = Product
