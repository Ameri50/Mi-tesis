import Foundation

// MARK: - RepairPart
struct RepairPart: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let compatibleModels: [String]
    let repairTime: String
    let stock: Bool
    let imageName: String
}
