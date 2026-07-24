import Foundation
import FirebaseFirestore

@MainActor
class ProductStore: ObservableObject {
    static let shared = ProductStore()

    @Published var products: [SeedProduct] = []
    @Published var isLoading = true

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private let localProducts = ProductData.products

    private struct ProductDraft {
        let id: String
        let name: String
        let price: Double?
        let category: String?
        let imageSource: String?
        let description: String?
        let stock: Int?
        let colorOptions: [ColorOption]?
        let storageOptions: [StorageOption]?
        let additionalImages: [String]?
        let rating: Double?
        let reviewCount: Int?
        let inStock: Bool?
        let isOnSale: Bool?
        let discount: Int?
    }

    private init() {
        products = localProducts
        startListening()
    }

    func startListening() {
        listener?.remove()
        listener = db.collection("products").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error escuchando productos: \(error.localizedDescription)")
                self.products = self.localProducts
                self.isLoading = false
                return
            }

            guard let documents = snapshot?.documents else {
                self.products = self.localProducts
                self.isLoading = false
                return
            }

            let localProducts = self.localProducts
            let documentPayloads = documents.map { ($0.documentID, $0.data()) }

            DispatchQueue.global(qos: .userInitiated).async {
                let localByKey = Dictionary(
                    uniqueKeysWithValues: localProducts.map {
                        (Self.productKey(name: $0.name, category: $0.category), $0)
                    }
                )

                let drafts = documentPayloads.compactMap { documentID, data in
                    Self.parseDraft(from: data, documentID: documentID)
                }

                var mergedProducts: [SeedProduct] = []
                var consumedWebKeys = Set<String>()

                for localProduct in localProducts {
                    let key = Self.productKey(name: localProduct.name, category: localProduct.category)
                    if let draft = drafts.first(where: {
                        Self.productKey(name: $0.name, category: $0.category ?? localProduct.category) == key
                    }) {
                        consumedWebKeys.insert(key)
                        mergedProducts.append(Self.materializeProduct(from: draft, fallback: localProduct))
                    } else {
                        mergedProducts.append(localProduct)
                    }
                }

                let newProducts = drafts.compactMap { draft -> SeedProduct? in
                    let key = Self.productKey(name: draft.name, category: draft.category ?? "Otros")
                    guard !consumedWebKeys.contains(key), localByKey[key] == nil else { return nil }
                    return Self.materializeProduct(from: draft, fallback: nil)
                }
                .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

                DispatchQueue.main.async {
                    let combinedProducts = mergedProducts + newProducts
                    let uniqueProducts = Self.deduplicatedProducts(combinedProducts)
                    self.products = uniqueProducts
                    self.isLoading = false
                    print("✅ ProductStore: \(uniqueProducts.count) productos únicos cargados")
                }
            }
        }
    }

    nonisolated private static func productKey(name: String, category: String) -> String {
        "\(name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())|\(category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())"
    }

    nonisolated private static func parseDraft(from data: [String: Any], documentID: String) -> ProductDraft? {
        guard let name = firstString(in: data, keys: ["name", "title"]), !name.isEmpty else {
            return nil
        }

        return ProductDraft(
            id: firstString(in: data, keys: ["id"]) ?? documentID,
            name: name,
            price: firstDouble(in: data, keys: ["price", "salePrice", "amount"]),
            category: firstString(in: data, keys: ["category", "type", "group"]),
            imageSource: firstString(in: data, keys: ["image_url", "imageURL", "imageUrl", "image", "imageName", "image_name"]),
            description: firstString(in: data, keys: ["description", "productDescription", "product_description", "details"]),
            stock: firstInt(in: data, keys: ["stock", "quantity", "availableStock"]),
            colorOptions: parseColorOptions(from: data),
            storageOptions: parseStorageOptions(from: data),
            additionalImages: parseStringArray(from: data, keys: ["additionalImages", "images", "galleryImages"]),
            rating: firstDouble(in: data, keys: ["rating", "stars"]),
            reviewCount: firstInt(in: data, keys: ["reviewCount", "reviewsCount"]),
            inStock: firstBool(in: data, keys: ["inStock", "available"]),
            isOnSale: firstBool(in: data, keys: ["isOnSale", "onSale"]),
            discount: firstInt(in: data, keys: ["discount", "discountPercent"])
        )
    }

    nonisolated private static func materializeProduct(from draft: ProductDraft, fallback: SeedProduct?) -> SeedProduct {
        let base = fallback

        let imageSource = draft.imageSource
            ?? base?.finalImageURL
            ?? base?.imageName
            ?? ""

        let description = draft.description
            ?? base?.description
            ?? ""

        let stock = draft.stock
            ?? base?.stock
            ?? 50

        let mergedColorOptions = draft.colorOptions
            ?? base?.colorOptions
            ?? []

        let mergedStorageOptions = draft.storageOptions
            ?? base?.storageOptions
            ?? []

        let mergedAdditionalImages = draft.additionalImages
            ?? base?.additionalImages
            ?? []

        let rating = draft.rating
            ?? base?.rating
            ?? 4.5

        let reviewCount = draft.reviewCount
            ?? base?.reviewCount
            ?? 0

        let isOnSale = draft.isOnSale
            ?? base?.isOnSale
            ?? false

        let discount = draft.discount
            ?? base?.discount
            ?? 0

        let inStock = draft.inStock
            ?? base?.inStock
            ?? (stock > 0)

        return SeedProduct(
            id: draft.id,
            name: draft.name,
            price: draft.price ?? base?.price ?? 0,
            category: draft.category ?? base?.category ?? "Otros",
            image_url: imageSource,
            description: description,
            stock: stock,
            colorOptions: mergedColorOptions,
            storageOptions: mergedStorageOptions,
            imageName: imageSource,
            additionalImages: mergedAdditionalImages,
            rating: rating,
            reviewCount: reviewCount,
            inStock: inStock,
            imageURL: imageSource.isEmpty ? nil : imageSource,
            isOnSale: isOnSale,
            discount: discount
        )
    }

    nonisolated private static func firstString(in data: [String: Any], keys: [String]) -> String? {
        for key in keys {
            if let string = data[key] as? String, !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return string
            }
        }
        return nil
    }

    nonisolated private static func firstDouble(in data: [String: Any], keys: [String]) -> Double? {
        for key in keys {
            if let value = data[key] as? Double {
                return value
            }
            if let value = data[key] as? Int {
                return Double(value)
            }
            if let value = data[key] as? String, let parsed = Double(value) {
                return parsed
            }
        }
        return nil
    }

    nonisolated private static func firstInt(in data: [String: Any], keys: [String]) -> Int? {
        for key in keys {
            if let value = data[key] as? Int {
                return value
            }
            if let value = data[key] as? Double, value.isFinite {
                return Int(value)
            }
            if let value = data[key] as? String, let parsed = Int(value) {
                return parsed
            }
        }
        return nil
    }

    nonisolated private static func firstBool(in data: [String: Any], keys: [String]) -> Bool? {
        for key in keys {
            if let value = data[key] as? Bool {
                return value
            }
            if let value = data[key] as? Int {
                return value != 0
            }
            if let value = data[key] as? String {
                let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if ["true", "1", "yes", "si", "sí"].contains(normalized) {
                    return true
                }
                if ["false", "0", "no"].contains(normalized) {
                    return false
                }
            }
        }
        return nil
    }

    nonisolated private static func parseStringArray(from data: [String: Any], keys: [String]) -> [String]? {
        for key in keys {
            if let array = data[key] as? [String] {
                return array.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            }
            if let array = data[key] as? [Any] {
                let values = array.compactMap { $0 as? String }
                    .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                return values
            }
            if let string = data[key] as? String {
                let values = string
                    .components(separatedBy: CharacterSet(charactersIn: ",;\n"))
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                if !values.isEmpty {
                    return values
                }
            }
        }
        return nil
    }

    nonisolated private static func parseColorOptions(from data: [String: Any]) -> [ColorOption]? {
        let keys = ["colorOptions", "allColors", "colors", "coloros"]
        for key in keys {
            guard let value = data[key] else { continue }

            if let array = value as? [[String: Any]] {
                let options = array.compactMap { dict -> ColorOption? in
                    guard let name = dict["name"] as? String ?? dict["title"] as? String else { return nil }
                    let hexColor = (dict["hexColor"] as? String)
                        ?? (dict["hex"] as? String)
                        ?? hexColor(for: name)
                    return ColorOption(name: name, hexColor: hexColor)
                }
                return options
            }

            if let array = value as? [String] {
                return array.map { name in
                    ColorOption(name: name, hexColor: hexColor(for: name))
                }
            }

            if let string = value as? String {
                let names = string
                    .components(separatedBy: CharacterSet(charactersIn: ",;\n"))
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                if !names.isEmpty {
                    return names.map { name in
                        ColorOption(name: name, hexColor: hexColor(for: name))
                    }
                }
            }
        }
        return nil
    }

    nonisolated private static func parseStorageOptions(from data: [String: Any]) -> [StorageOption]? {
        let keys = ["storageOptions", "allStorages", "storages", "gigas", "storage"]
        for key in keys {
            guard let value = data[key] else { continue }

            if let array = value as? [[String: Any]] {
                let options = array.compactMap { dict -> StorageOption? in
                    guard let capacity = dict["capacity"] as? String ?? dict["name"] as? String ?? dict["size"] as? String else { return nil }
                    let multiplier = Self.safeDouble(dict["priceMultiplier"]) ?? 1.0
                    return StorageOption(capacity: capacity, priceMultiplier: multiplier)
                }
                return options
            }

            if let array = value as? [String] {
                return array.map { rawCapacity in
                    let capacity = normalizeCapacity(rawCapacity)
                    return StorageOption(capacity: capacity, priceMultiplier: 1.0)
                }
            }

            if let string = value as? String {
                let capacities = string
                    .components(separatedBy: CharacterSet(charactersIn: ",;\n"))
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                if !capacities.isEmpty {
                    return capacities.map { rawCapacity in
                        let capacity = normalizeCapacity(rawCapacity)
                        return StorageOption(capacity: capacity, priceMultiplier: 1.0)
                    }
                }
            }
        }
        return nil
    }

    nonisolated private static func safeDouble(_ value: Any?) -> Double? {
        if let doubleValue = value as? Double, doubleValue.isFinite {
            return doubleValue
        }
        if let intValue = value as? Int {
            return Double(intValue)
        }
        if let stringValue = value as? String, let parsed = Double(stringValue), parsed.isFinite {
            return parsed
        }
        return nil
    }

    nonisolated private static func normalizeCapacity(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let uppercased = trimmed.uppercased()
        if uppercased.hasSuffix("GB") || uppercased.hasSuffix("TB") {
            return uppercased
        }
        if let number = Int(trimmed) {
            return "\(number)GB"
        }
        return trimmed
    }

    nonisolated private static func hexColor(for name: String) -> String {
        switch name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "negro", "negro espacial", "space black", "black", "grafito":
            return "#1C1C1E"
        case "blanco", "plata", "silver", "white", "luz estelar", "starlight":
            return "#E8E8ED"
        case "gris", "gris espacial", "space gray", "space grey":
            return "#3A3A3C"
        case "medianoche", "midnight":
            return "#222930"
        case "oro", "gold":
            return "#D4AF37"
        case "oro rosa", "rose gold":
            return "#E8B4B8"
        case "rojo", "red", "product red":
            return "#FF3B30"
        case "azul", "blue":
            return "#3478F6"
        case "azul cielo", "sky blue", "celeste":
            return "#7EC8E3"
        case "verde", "green":
            return "#30D158"
        case "morado", "purple":
            return "#BF5AF2"
        case "naranja", "orange":
            return "#FF9F0A"
        case "amarillo", "yellow":
            return "#FFD60A"
        case "rosa", "pink":
            return "#F2A7BB"
        case "teal":
            return "#3E7A7E"
        default:
            return "#8E8E93"
        }
    }

    nonisolated private static func deduplicatedProducts(_ products: [SeedProduct]) -> [SeedProduct] {
        var seenKeys = Set<String>()
        var uniqueProducts: [SeedProduct] = []

        for product in products {
            let key = productKey(name: product.name, category: product.category)
            guard seenKeys.insert(key).inserted else { continue }
            uniqueProducts.append(product)
        }

        return uniqueProducts
    }
}
