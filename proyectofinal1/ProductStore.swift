import Foundation
import FirebaseFirestore

@MainActor
class ProductStore: ObservableObject {
    static let shared = ProductStore()

    @Published var products: [SeedProduct] = []
    @Published var isLoading = true

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    private init() {
        startListening()
    }

    func startListening() {
        listener?.remove()
        listener = db.collection("products").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error escuchando productos: \(error.localizedDescription)")
                self.isLoading = false
                return
            }

            guard let documents = snapshot?.documents else {
                self.products = []
                self.isLoading = false
                return
            }

            self.products = documents.compactMap { self.parseProduct(from: $0.data()) }
            self.isLoading = false
            print("✅ ProductStore: \(self.products.count) productos cargados desde Firestore")
        }
    }

    private func parseProduct(from data: [String: Any]) -> SeedProduct? {
        guard let name = data["name"] as? String, !name.isEmpty else { return nil }

        let price: Double = (data["price"] as? Double)
            ?? Double(data["price"] as? Int ?? 0)

        let category = (data["category"] as? String) ?? "Otros"

        // 🖼️ Imagen — acepta el formato del panel web (image_url/imageURL)
        // y el formato del seed automático (imageName)
        let imageSource = (data["image_url"] as? String)
            ?? (data["imageURL"] as? String)
            ?? (data["imageName"] as? String)
            ?? ""

        // 📝 Descripción — acepta el formato del panel web (description)
        // y el formato del seed automático (productDescription)
        let description = (data["description"] as? String)
            ?? (data["productDescription"] as? String)
            ?? ""

        let stock = (data["stock"] as? Int) ?? 50

        // 🖼️ Imágenes adicionales (opcional) — antes estaba fijo en []
        let additionalImages = (data["additionalImages"] as? [String]) ?? []

        // 🎨 Colores (opcional)
        var colorOptions: [ColorOption] = []
        if let colorsData = data["colorOptions"] as? [[String: Any]] {
            colorOptions = colorsData.compactMap { dict in
                guard let colorName = dict["name"] as? String,
                      let hexColor = dict["hexColor"] as? String else { return nil }
                return ColorOption(name: colorName, hexColor: hexColor)
            }
        }

        // 💾 Capacidades / GB (opcional)
        var storageOptions: [StorageOption] = []
        if let storagesData = data["storageOptions"] as? [[String: Any]] {
            storageOptions = storagesData.compactMap { dict in
                guard let capacity = dict["capacity"] as? String else { return nil }
                let multiplier = (dict["priceMultiplier"] as? Double)
                    ?? Double(dict["priceMultiplier"] as? Int ?? 1)
                return StorageOption(capacity: capacity, priceMultiplier: multiplier)
            }
        }

        return SeedProduct(
            name: name,
            price: price,
            category: category,
            imageName: imageSource,
            additionalImages: additionalImages,
            productDescription: description,
            colorOptions: colorOptions,
            storageOptions: storageOptions,
            stock: stock,
            inStock: stock > 0
        )
    }
}
