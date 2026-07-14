import Foundation

struct ProductModel: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var description: String
    var price: Double
    var category: String
    var images: [URL]
    var stock: Int

    // Convenience init to accept [String] URLs if needed
    init(id: String, name: String, description: String, price: Double, category: String, images: [URL], stock: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.category = category
        self.images = images
        self.stock = stock
    }
}
