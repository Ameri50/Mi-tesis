import Foundation

// MARK: - Color Option
struct ColorOption: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let hexColor: String
}

// MARK: - Storage Option
struct StorageOption: Identifiable, Equatable {
    let id = UUID()
    let capacity: String
    let priceMultiplier: Double
}

// MARK: - SeedProduct
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
        colorOptions: [ColorOption] = [],
        storageOptions: [StorageOption] = [],
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
        self.stock = stock
        self.rating = rating
        self.reviewCount = reviewCount
        self.isOnSale = isOnSale
        self.discount = discount
        self.inStock = inStock
        super.init()
    }

    var discountedPrice: Double {
        guard isOnSale && discount > 0 else { return price }
        return price - (price * Double(discount) / 100)
    }

    var stockStatus: String {
        if !inStock        { return "Agotado" }
        else if stock <= 5 { return "Últimas unidades" }
        else if stock <= 10 { return "Stock bajo" }
        else               { return "En stock" }
    }

    var stockColor: String {
        if !inStock        { return "red" }
        else if stock <= 5 { return "orange" }
        else               { return "green" }
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SeedProduct else { return false }
        return self.id == other.id
    }

    override var hash: Int { id.hashValue }
}
