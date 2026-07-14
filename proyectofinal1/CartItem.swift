// CartItem.swift
import Foundation

struct CartItem: Identifiable, Codable {
    var id: UUID
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
    
    init(product: Product, quantity: Int = 1, id: UUID = UUID()) {
        self.product = product
        self.quantity = max(1, quantity)
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, product, quantity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.product = try container.decode(Product.self, forKey: .product)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(product, forKey: .product)
        try container.encode(quantity, forKey: .quantity)
    }
}
