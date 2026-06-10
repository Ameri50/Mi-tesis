import Foundation

// MARK: - Color Option
struct ColorOption: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let hexColor: String
    
    static let allColors = [
        ColorOption(name: "Gris Espacial", hexColor: "#2C2C2C"),
        ColorOption(name: "Plata", hexColor: "#E5E5EA"),
        ColorOption(name: "Oro", hexColor: "#FFD700"),
        ColorOption(name: "Negro", hexColor: "#000000"),
        ColorOption(name: "Púrpura", hexColor: "#A855F7")
    ]
}

// MARK: - Storage Option
struct StorageOption: Identifiable, Equatable {
    let id = UUID()
    let capacity: String
    let priceMultiplier: Double
    
    static let allStorages = [
        StorageOption(capacity: "128GB", priceMultiplier: 1.0),
        StorageOption(capacity: "256GB", priceMultiplier: 1.15),
        StorageOption(capacity: "512GB", priceMultiplier: 1.30),
        StorageOption(capacity: "1TB", priceMultiplier: 1.50)
    ]
}

// MARK: - SeedProduct (CLASS) - MEJORADO
class SeedProduct: NSObject, Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let category: String
    let imageName: String
    let additionalImages: [String]
    let productDescription: String
    let colorOptions: [ColorOption]
    let storageOptions: [StorageOption]
    
    // 🆕 NUEVOS CAMPOS - Mejoras para Firebase
    let stock: Int
    let rating: Double
    let reviewCount: Int
    let isOnSale: Bool
    let discount: Int
    let inStock: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        category: String,
        imageName: String,
        additionalImages: [String],
        productDescription: String,
        colorOptions: [ColorOption] = ColorOption.allColors,
        storageOptions: [StorageOption] = StorageOption.allStorages,
        // 🆕 Nuevos parámetros con valores por defecto
        stock: Int = 50,
        rating: Double = 4.5,
        reviewCount: Int = 0,
        isOnSale: Bool = false,
        discount: Int = 0,
        inStock: Bool = true
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.imageName = imageName
        self.additionalImages = additionalImages
        self.productDescription = productDescription
        self.colorOptions = colorOptions
        self.storageOptions = storageOptions
        // 🆕 Inicializar nuevos campos
        self.stock = stock
        self.rating = rating
        self.reviewCount = reviewCount
        self.isOnSale = isOnSale
        self.discount = discount
        self.inStock = inStock
        super.init()
    }
    
    // 🆕 Computed Property - Precio con descuento
    var discountedPrice: Double {
        guard isOnSale && discount > 0 else { return price }
        let discountAmount = price * Double(discount) / 100
        return price - discountAmount
    }
    
    // 🆕 Computed Property - Mostrar estado de stock
    var stockStatus: String {
        if !inStock {
            return "Agotado"
        } else if stock <= 5 {
            return "Últimas unidades"
        } else if stock <= 10 {
            return "Stock bajo"
        } else {
            return "En stock"
        }
    }
    
    // 🆕 Computed Property - Color de stock
    var stockColor: String {
        if !inStock {
            return "red"
        } else if stock <= 5 {
            return "orange"
        } else {
            return "green"
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SeedProduct else { return false }
        return self.id == other.id
    }
    
    override var hash: Int {
        return id.hashValue
    }
}
