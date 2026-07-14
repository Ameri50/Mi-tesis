import Foundation

struct SimpleProduct: Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let category: String
    let imageName: String

    init(id: UUID = UUID(), name: String, price: Double, category: String, imageName: String) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.imageName = imageName
    }
}
