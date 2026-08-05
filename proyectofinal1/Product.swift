import Foundation

// MARK: - Enums para categorías y tipos de dispositivos
enum DeviceCategory: String, CaseIterable, Codable {
    case iPhone = "iPhone"
    case iPad = "iPad"
    case Mac = "Mac"
    case MacBook = "MacBook"
    case appleWatch = "Apple Watch"
    case airPods = "AirPods"
    case accesorios = "Accesorios"
    case otros = "Otros"
}

// MARK: - ColorOption
struct ColorOption: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var hexColor: String

    init(name: String, hexColor: String) {
        self.id = UUID()
        self.name = name
        self.hexColor = hexColor
    }

    enum CodingKeys: String, CodingKey {
        case name, hexColor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(hexColor)
    }
}

// MARK: - StorageOption
struct StorageOption: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var capacity: String
    var priceMultiplier: Double = 1.0

    init(capacity: String, priceMultiplier: Double = 1.0) {
        self.id = UUID()
        self.capacity = capacity
        self.priceMultiplier = priceMultiplier
    }

    enum CodingKeys: String, CodingKey {
        case capacity, priceMultiplier
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(capacity)
        hasher.combine(priceMultiplier)
    }
}

// MARK: - Product (modelo principal mejorado)
struct Product: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var price: Double
    var category: String
    var image_url: String = ""
    var description: String = ""
    var stock: Int = 50
    var colorOptions: [ColorOption] = []
    var storageOptions: [StorageOption] = []
    var imageName: String = ""
    var additionalImages: [String] = []
    var rating: Double = 4.5
    var reviewCount: Int = 0
    var inStock: Bool = true
    var imageURL: String?
    var isOnSale: Bool = false
    var discount: Int = 0
    var suggestedDevices: [String] = []
    var tags: [String] = []
    var compatibleWith: [String] = []
    
    // Campos adicionales para compatibilidad
    var specs: String = ""
    var reviews: [String] = []
    var weight: Double = 0
    var dimensions: String = ""
    var color: String = ""

    // MARK: - Computed Properties
    var finalImageURL: String {
        if let url = imageURL, !url.isEmpty {
            return url
        }
        if !image_url.isEmpty {
            return image_url
        }
        return imageName
    }

    /// Estado del stock para mostrar
    var stockStatus: String {
        let language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es"

        if language == "en" {
            if !inStock { return "Out of Stock" }
            if stock <= 5 { return "Last units" }
            if stock <= 10 { return "Low Stock" }
            return "In Stock"
        } else {
            if !inStock { return "Agotado" }
            if stock <= 5 { return "Ultimas unidades" }
            if stock <= 10 { return "Stock bajo" }
            return "En stock"
        }
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

    var displayDescription: String {
        Self.translateDescription(description)
    }

    var productDescription: String {
        get { description }
        set { description = newValue }
    }

    enum CodingKeys: String, CodingKey {
        case id, name, price, category
        case image_url, description, stock
        case colorOptions, storageOptions
        case imageName, additionalImages
        case rating, reviewCount
        case inStock, imageURL
        case isOnSale, discount
        case suggestedDevices, tags, compatibleWith
        case specs, reviews, weight, dimensions, color
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
        suggestedDevices: [String] = [],
        tags: [String] = [],
        compatibleWith: [String] = [],
        specs: String = "",
        reviews: [String] = [],
        weight: Double = 0,
        dimensions: String = "",
        color: String = ""
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
        self.suggestedDevices = suggestedDevices
        self.tags = tags
        self.compatibleWith = compatibleWith
        self.specs = specs
        self.reviews = reviews
        self.weight = weight
        self.dimensions = dimensions
        self.color = color
    }

    // MARK: - Inicializador alternativo para compatibilidad
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

    // MARK: - Inicializador alternativo 2
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
        additionalImages: [String]? = nil,
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
            suggestedDevices: suggestedDevices, specs: specs,
            reviews: reviews,
            weight: weight,
            dimensions: dimensions,
            color: color
        )
    }

    // MARK: - Traducción de descripciones
    private static func translateDescription(_ raw: String) -> String {
        var text = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        let sentenceReplacements: [(String, String)] = [
            ("El iPhone más accesible de la familia 17.", "The most affordable iPhone in the 17 family."),
            ("El iPhone más potente.", "The most powerful iPhone."),
            ("El iPhone más delgado de la historia (5.6 mm).", "The thinnest iPhone ever (5.6 mm)."),
            ("El iPhone más pequeño de su generación.", "The smallest iPhone of its generation."),
            ("El mejor valor de la gama actual.", "The best value in the current lineup."),
            ("Opción de entrada con chip A18 y Apple Intelligence.", "Entry-level option with the A18 chip and Apple Intelligence."),
            ("La opción más económica con botón de inicio.", "The most affordable option with a Home button."),
            ("Primera iPad Air de 13\".", "The first 13\" iPad Air."),
            ("Primera iPad Air con 5G y Center Stage.", "First iPad Air with 5G and Center Stage."),
            ("El mini más potente.", "The most powerful mini."),
            ("Rendimiento extremo.", "Extreme performance."),
            ("Para videófilos, músicos y diseñadores 3D.", "For videographers, musicians, and 3D designers."),
            ("El Mac más pequeño de la historia.", "The smallest Mac ever."),
            ("El portátil más vendido del mundo.", "The world's best-selling laptop."),
            ("Todo-en-uno con pantalla Retina 4.5K de 24\".", "All-in-one with a 24\" Retina 4.5K display."),
            ("Diseño ultrafino en 7 colores vibrantes.", "Ultra-thin design in 7 vibrant colors."),
            ("Rediseño histórico compacto de 12.7×12.7 cm.", "Historic compact redesign of 12.7 × 12.7 cm."),
            ("Rediseño total con Touch ID lateral y USB-C.", "Complete redesign with side Touch ID and USB-C."),
            ("Batería de larga duración.", "Long battery life."),
            ("Compatible con Apple Pencil Pro y Magic Keyboard.", "Compatible with Apple Pencil Pro and Magic Keyboard."),
            ("Compatible con Apple Pencil Pro.", "Compatible with Apple Pencil Pro."),
            ("Compatible con Apple Pencil 2ª gen.", "Compatible with 2nd-gen Apple Pencil."),
            ("Compatible con Apple Pencil 1ª gen.", "Compatible with 1st-gen Apple Pencil."),
            ("Compatible con Apple Pencil USB-C.", "Compatible with USB-C Apple Pencil."),
            ("Compatible con Smart Keyboard y Apple Pencil 1ª gen.", "Compatible with Smart Keyboard and 1st-gen Apple Pencil."),
            ("Compatible con Smart Keyboard.", "Compatible with Smart Keyboard."),
            ("Compatible con Magic Keyboard.", "Compatible with Magic Keyboard."),
            ("Chip M4, 16 GB RAM. Sin ventilador.", "M4 chip, 16 GB of RAM. Fanless design."),
            ("Chip M4, 16 GB RAM.", "M4 chip, 16 GB of RAM."),
            ("Chip M5 Max, hasta 128 GB de RAM unificada. Thunderbolt 5. Hasta 22 h de batería.", "M5 Max chip, up to 128 GB of unified memory. Thunderbolt 5. Up to 22 hours of battery life."),
            ("Chip M4 Pro, 24 GB RAM. Thunderbolt 5. Hasta 24 h de batería.", "M4 Pro chip, 24 GB of RAM. Thunderbolt 5. Up to 24 hours of battery life."),
            ("Chip M4 Pro, 24 GB RAM. Thunderbolt 5.", "M4 Pro chip, 24 GB of RAM. Thunderbolt 5."),
            ("Chip M4 Max, 36 GB RAM unificada. Thunderbolt 5. Para videófilos, músicos y diseñadores 3D.", "M4 Max chip, 36 GB of unified memory. Thunderbolt 5. For videographers, musicians, and 3D designers."),
            ("Chip M4 Ultra, hasta 192 GB RAM unificada. Para rendering industrial, ML y postproducción.", "M4 Ultra chip, up to 192 GB of unified memory. For industrial rendering, ML, and post-production."),
            ("Chip A15 Bionic. El iPad de entrada más popular.", "A15 Bionic chip. The most popular entry-level iPad.")
        ]

        for (source, target) in sentenceReplacements {
            text = text.replacingOccurrences(of: source, with: target)
        }

        let phraseReplacements: [(String, String)] = [
            ("Pantalla Super Retina XDR de ", "Super Retina XDR display of "),
            ("Pantalla Liquid Retina XDR de ", "Liquid Retina XDR display of "),
            ("Pantalla Liquid Retina de ", "Liquid Retina display of "),
            ("Pantalla OLED de ", "OLED display of "),
            ("Pantalla Retina HD de ", "Retina HD display of "),
            ("Pantalla Retina de ", "Retina display of "),
            ("Pantalla Tandem OLED Ultra Retina XDR de ", "Tandem OLED Ultra Retina XDR display of "),
            ("cámara triple", "triple camera"),
            ("cámara dual", "dual camera"),
            ("cámara", "camera"),
            ("compatible con", "compatible with"),
            ("Chasis de titanio aeroespacial", "Aerospace-grade titanium chassis"),
            ("chasis de titanio aeroespacial", "aerospace-grade titanium chassis"),
            ("Chasis de aluminio aeroespacial", "Aerospace-grade aluminum chassis"),
            ("chasis de aluminio aeroespacial", "aerospace-grade aluminum chassis"),
            ("Diseño ultrafino", "Ultra-thin design"),
            ("diseño ultrafino", "ultra-thin design"),
            ("Diseño ultraligero", "Ultra-light design"),
            ("diseño ultraligero", "ultra-light design"),
            ("Muesca más pequeña", "Smaller notch"),
            ("muesca más pequeña", "smaller notch"),
            ("Batería de larga duración", "Long battery life"),
            ("batería de larga duración", "long battery life")
        ]

        for (source, target) in phraseReplacements {
            text = text.replacingOccurrences(of: source, with: target)
        }

        text = text.replacingOccurrences(of: "  ", with: " ")
        text = text.replacingOccurrences(of: " ,", with: ",")
        text = text.replacingOccurrences(of: " .", with: ".")
        text = text.replacingOccurrences(of: " of  ", with: " of ")

        return text
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(price)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - SeedProduct (para compatibilidad)
typealias SeedProduct = Product

// MARK: - Recomendaciones mejoradas
private let accessoryCategoryKeyword = "accesorio"

extension Array where Element == Product {
    /// Productos relacionados a `product`: misma categoría, excluyéndolo a él mismo
    /// y priorizando los que están en stock
    func related(to product: Product, limit: Int = 10) -> [Product] {
        let sameCategory = self.filter {
            $0.id != product.id &&
            $0.category == product.category
        }
        let inStockFirst = sameCategory.sorted {
            $0.inStock && !$1.inStock
        }
        return Array(inStockFirst.prefix(limit))
    }

    /// Accesorios personalizados para `product`
    /// Prioriza accesorios que tienen suggestedDevices que coinciden con el producto
    func accessories(for product: Product, limit: Int = 10) -> [Product] {
        let pool = self.filter {
            $0.id != product.id &&
            $0.category.localizedCaseInsensitiveContains(accessoryCategoryKeyword)
        }
        guard !pool.isEmpty else { return [] }

        // Intenta encontrar accesorios que coincidan con suggestedDevices
        let matched = pool.filter { accessory in
            // Si el accesorio NO tiene suggestedDevices, no lo incluye en matched
            guard !accessory.suggestedDevices.isEmpty else { return false }
            
            return accessory.suggestedDevices.contains { device in
                // Compara con la categoría del producto actual
                device.localizedCaseInsensitiveContains(product.category)
                    // O compara con el nombre del producto
                    || product.name.localizedCaseInsensitiveContains(device)
                    // O compara con compatibleWith
                    || product.compatibleWith.contains { compat in
                        device.localizedCaseInsensitiveContains(compat)
                    }
            }
        }

        if !matched.isEmpty {
            // Prioriza matched, luego el resto
            let matchedIds = Set(matched.map { $0.id })
            let rest = pool.filter { !matchedIds.contains($0.id) }
            return Array((matched + rest).prefix(limit))
        }
        
        // Si no hay matches, devuelve accesorios genéricos (los sin suggestedDevices)
        let generic = pool.filter { $0.suggestedDevices.isEmpty }
        return Array((generic + pool).prefix(limit))
    }

    /// Accesorios alternativos para búsqueda cruzada
    func accessoriesForCategory(_ category: String, limit: Int = 10) -> [Product] {
        let pool = self.filter {
            $0.category.localizedCaseInsensitiveContains(accessoryCategoryKeyword)
        }
        guard !pool.isEmpty else { return [] }

        let matched = pool.filter { accessory in
            accessory.suggestedDevices.contains { device in
                device.localizedCaseInsensitiveContains(category)
            }
        }

        if !matched.isEmpty {
            return Array(matched.prefix(limit))
        }
        return Array(pool.prefix(limit))
    }

    /// Recomendaciones para el carrito: productos que NO están ya en el carrito
    /// Prioriza accesorios compatibles con lo que el usuario ya lleva
    func recommendations(
        excluding excludedIds: Set<String>,
        favoringCategories categories: Set<String>,
        limit: Int = 10
    ) -> [Product] {
        let candidates = self.filter { !excludedIds.contains($0.id) }

        func score(_ p: Product) -> Int {
            // Si es accesorio
            if p.category.localizedCaseInsensitiveContains(accessoryCategoryKeyword) {
                // ¿Coincide con alguna categoría del carrito?
                let matchesCartItem = p.suggestedDevices.contains { device in
                    categories.contains { cartCategory in
                        cartCategory.localizedCaseInsensitiveContains(device)
                            || device.localizedCaseInsensitiveContains(cartCategory)
                    }
                }
                // Accesorio que coincide: 3 puntos + 1 si está en stock = 4 máximo
                return (matchesCartItem ? 3 : 2) + (p.inStock ? 1 : 0)
            }
            
            // Si es de la misma categoría
            if categories.contains(p.category) {
                return 1 + (p.inStock ? 1 : 0)
            }
            
            // Otros productos
            return p.inStock ? 1 : 0
        }

        let sorted = candidates.sorted { score($0) > score($1) }
        return Array(sorted.prefix(limit))
    }

    /// Busca productos por sugerencia de dispositivo
    func productsForDevice(_ deviceName: String, limit: Int = 10) -> [Product] {
        let matched = self.filter { product in
            product.suggestedDevices.contains { device in
                device.localizedCaseInsensitiveContains(deviceName)
            }
        }
        return Array(matched.prefix(limit))
    }

    /// Busca productos por tags
    func productsByTag(_ tag: String, limit: Int = 10) -> [Product] {
        let matched = self.filter { product in
            product.tags.contains { t in
                t.localizedCaseInsensitiveCompare(tag) == .orderedSame
            }
        }
        return Array(matched.prefix(limit))
    }
}
