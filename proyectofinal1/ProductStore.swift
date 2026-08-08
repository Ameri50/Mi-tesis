import Foundation
import FirebaseFirestore

@MainActor
class ProductStore: ObservableObject {
    static let shared = ProductStore()

    @Published var products: [Product] = []
    @Published var isLoading = true
    @Published var accessories: [Product] = []
    @Published var relatedProducts: [Product] = []

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
        let suggestedDevices: [String]?
        let tags: [String]?
        let compatibleWith: [String]?
    }

    private init() {
        startListening()
    }

    func startListening() {
        listener?.remove()
        isLoading = true

        listener = db.collection("products").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error escuchando productos: \(error.localizedDescription)")
                Task { @MainActor in
                    self.products = self.localProducts
                    self.updateAccessories()
                    self.isLoading = false
                }
                return
            }

            guard let documents = snapshot?.documents else {
                Task { @MainActor in
                    self.products = []
                    self.updateAccessories()
                    self.isLoading = false
                }
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

                let firestoreProducts = drafts.map { draft in
                    let key = Self.productKey(name: draft.name, category: draft.category ?? "Otros")
                    return Self.materializeProduct(from: draft, fallback: localByKey[key])
                }

                DispatchQueue.main.async {
                    let uniqueProducts = Self.deduplicatedProducts(firestoreProducts)
                    self.products = uniqueProducts
                    self.updateAccessories()
                    self.isLoading = false
                    print("✅ ProductStore: \(uniqueProducts.count) productos cargados desde Firestore")
                }
            }
        }
    }

    private func updateAccessories() {
        self.accessories = products.filter {
            $0.category.localizedCaseInsensitiveContains("accesorio")
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
            discount: firstInt(in: data, keys: ["discount", "discountPercent"]),
            suggestedDevices: parseStringArray(from: data, keys: ["suggestedDevices", "deviceTypes", "compatibleDevices"]),
            tags: parseStringArray(from: data, keys: ["tags", "labels"]),
            compatibleWith: parseStringArray(from: data, keys: ["compatibleWith", "compatible"])
        )
    }

    nonisolated private static func materializeProduct(from draft: ProductDraft, fallback: Product?) -> Product {
        let base = fallback

        let imageSource = draft.imageSource
            ?? base?.finalImageURL
            ?? base?.imageName
            ?? ""

        let category = draft.category ?? base?.category ?? "Otros"

        let stock = draft.stock
            ?? base?.stock
            ?? 50

        let inferredColorOptions = inferColorOptions(
            from: [draft.name, imageSource, category, base?.color ?? ""]
        )
        let mergedColorOptions = nonEmpty(draft.colorOptions)
            ?? nonEmpty(base?.colorOptions)
            ?? inferredColorOptions

        let mergedStorageOptions = draft.storageOptions
            ?? base?.storageOptions
            ?? []

        let description = meaningfulDescription(draft.description)
            ?? meaningfulDescription(base?.description)
            ?? generatedDescription(
                name: draft.name,
                category: category,
                imageSource: imageSource,
                colorOptions: mergedColorOptions,
                storageOptions: mergedStorageOptions
            )

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

        // ⭐ NUEVO: Maneja suggestedDevices
        let suggestedDevices = draft.suggestedDevices
            ?? base?.suggestedDevices
            ?? []

        // ⭐ NUEVO: Maneja tags
        let tags = draft.tags
            ?? base?.tags
            ?? []

        // ⭐ NUEVO: Maneja compatibleWith
        let compatibleWith = draft.compatibleWith
            ?? base?.compatibleWith
            ?? []

        return Product(
            id: draft.id,
            name: draft.name,
            price: draft.price ?? base?.price ?? 0,
            category: category,
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
            discount: discount,
            suggestedDevices: suggestedDevices,
            tags: tags,
            compatibleWith: compatibleWith
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
            if let doubleValue = data[key] as? Double, doubleValue.isFinite {
                return doubleValue
            }
            if let intValue = data[key] as? Int {
                return Double(intValue)
            }
            if let stringValue = data[key] as? String, let parsed = Double(stringValue), parsed.isFinite {
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
        let keys = ["colorOptions", "allColors", "colors", "coloros", "color", "colour"]
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

    nonisolated private static func nonEmpty(_ options: [ColorOption]?) -> [ColorOption]? {
        guard let options, !options.isEmpty else { return nil }
        return deduplicatedColorOptions(options)
    }

    nonisolated private static func meaningfulDescription(_ raw: String?) -> String? {
        guard let raw else { return nil }
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count >= 18 else { return nil }

        let lowercased = text.lowercased()
        let genericFragments = ["producto", "sin descripcion", "sin descripción", "description", "descripcion"]
        if genericFragments.contains(where: { lowercased == $0 }) {
            return nil
        }

        return text
    }

    nonisolated private static func generatedDescription(
        name: String,
        category: String,
        imageSource: String,
        colorOptions: [ColorOption],
        storageOptions: [StorageOption]
    ) -> String {
        var details: [String] = []
        details.append("Producto Apple de la categoria \(category), mostrado con la imagen principal de \(imageDescription(from: imageSource, fallback: name)).")

        if !colorOptions.isEmpty {
            details.append("Colores disponibles: \(colorOptions.map(\.name).joined(separator: ", ")).")
        }

        if !storageOptions.isEmpty {
            details.append("Capacidades disponibles: \(storageOptions.map(\.capacity).joined(separator: ", ")).")
        }

        details.append(categoryDescription(for: category))
        return details.joined(separator: " ")
    }

    nonisolated private static func imageDescription(from imageSource: String, fallback: String) -> String {
        let trimmed = imageSource.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return fallback }

        if trimmed.hasPrefix("http") {
            return "la foto subida desde la web"
        }

        return trimmed
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
    }

    nonisolated private static func categoryDescription(for category: String) -> String {
        let normalized = category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if normalized.contains("iphone") {
            return "Ideal para uso diario, fotografia, video y rendimiento movil."
        }
        if normalized.contains("ipad") {
            return "Pensado para estudio, entretenimiento, dibujo y productividad portatil."
        }
        if normalized.contains("mac") {
            return "Recomendado para trabajo, estudio, edicion y tareas de alto rendimiento."
        }
        if normalized.contains("watch") {
            return "Orientado a salud, deporte, notificaciones y seguimiento diario."
        }
        if normalized.contains("airpods") || normalized.contains("audio") {
            return "Diseniado para audio inalambrico, llamadas y movilidad."
        }
        if normalized.contains("accesorio") || normalized.contains("accessor") {
            return "Complementa tu dispositivo Apple y mejora la experiencia de uso."
        }
        return "Una opcion practica para completar tu ecosistema Apple."
    }

    nonisolated private static func inferColorOptions(from sources: [String]) -> [ColorOption] {
        let catalog: [(tokens: [String], option: ColorOption)] = [
            (["negro espacial", "space black", "black", "negro"], ColorOption(name: "Negro", hexColor: "#1C1C1E")),
            (["gris espacial", "space gray", "space grey", "gray", "grey", "gris", "grafito"], ColorOption(name: "Gris Espacial", hexColor: "#3A3A3C")),
            (["blanco", "white"], ColorOption(name: "Blanco", hexColor: "#F5F5F0")),
            (["plata", "silver"], ColorOption(name: "Plata", hexColor: "#E8E8ED")),
            (["luz estelar", "starlight"], ColorOption(name: "Luz Estelar", hexColor: "#F0EDE4")),
            (["medianoche", "midnight"], ColorOption(name: "Medianoche", hexColor: "#222930")),
            (["titanio desierto", "desert titanio", "desert titanium"], ColorOption(name: "Titanio Desierto", hexColor: "#C6A882")),
            (["titanio natural", "natural titanium"], ColorOption(name: "Titanio Natural", hexColor: "#C8B89A")),
            (["titanio", "titanium"], ColorOption(name: "Titanio", hexColor: "#8E8E93")),
            (["oro rosa", "rose gold"], ColorOption(name: "Oro Rosa", hexColor: "#E8B4B8")),
            (["oro", "gold"], ColorOption(name: "Oro", hexColor: "#D4AF37")),
            (["azul cielo", "sky blue", "celeste"], ColorOption(name: "Azul Cielo", hexColor: "#7EC8E3")),
            (["azul", "blue"], ColorOption(name: "Azul", hexColor: "#3478F6")),
            (["verde", "green"], ColorOption(name: "Verde", hexColor: "#30D158")),
            (["morado", "purple"], ColorOption(name: "Morado", hexColor: "#BF5AF2")),
            (["amarillo", "yellow"], ColorOption(name: "Amarillo", hexColor: "#FFD60A")),
            (["naranja", "orange"], ColorOption(name: "Naranja", hexColor: "#FF9F0A")),
            (["rosa", "pink"], ColorOption(name: "Rosa", hexColor: "#F2A7BB")),
            (["rojo", "red"], ColorOption(name: "Rojo", hexColor: "#FF3B30")),
            (["teal"], ColorOption(name: "Teal", hexColor: "#3E7A7E"))
        ]

        let normalizedSources = sources
            .map { $0.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "-", with: " ").lowercased() }

        let matched = catalog.compactMap { entry -> ColorOption? in
            normalizedSources.contains { source in
                entry.tokens.contains { source.contains($0) }
            } ? entry.option : nil
        }

        return deduplicatedColorOptions(matched)
    }

    nonisolated private static func deduplicatedColorOptions(_ options: [ColorOption]) -> [ColorOption] {
        var seen = Set<String>()
        var unique: [ColorOption] = []
        for option in options {
            let key = option.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard !key.isEmpty, seen.insert(key).inserted else { continue }
            unique.append(option)
        }
        return unique
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

    nonisolated private static func deduplicatedProducts(_ products: [Product]) -> [Product] {
        var seenKeys = Set<String>()
        var uniqueProducts: [Product] = []

        for product in products {
            let key = productKey(name: product.name, category: product.category)
            guard seenKeys.insert(key).inserted else { continue }
            uniqueProducts.append(product)
        }

        return uniqueProducts
    }
}
