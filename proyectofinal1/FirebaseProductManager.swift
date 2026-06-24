import Foundation
import FirebaseFirestore

class FirebaseProductManager {
    static let shared = FirebaseProductManager()
    private let db = Firestore.firestore()

    // MARK: - Cargar productos a Firebase
    func uploadProductsToFirebase(completion: @escaping (Bool) -> Void) {
        let products = ProductData.products

        print("📤 Iniciando carga de \(products.count) productos a Firebase...")

        var uploadedCount = 0
        let group = DispatchGroup()

        for product in products {
            group.enter()

            let productData: [String: Any] = [
                "id": product.id.uuidString,
                "name": product.name,
                "price": product.price,
                "category": product.category,
                "imageName": product.imageName,
                "additionalImages": product.additionalImages,
                "productDescription": product.productDescription,
                "colorOptions": product.colorOptions.map { ["name": $0.name, "hexColor": $0.hexColor] },
                "storageOptions": product.storageOptions.map { ["capacity": $0.capacity, "priceMultiplier": $0.priceMultiplier] },
                "stock": product.stock,
                "rating": product.rating,
                "reviewCount": product.reviewCount,
                "isOnSale": product.isOnSale,
                "discount": product.discount,
                "inStock": product.inStock,
                "createdAt": Timestamp(date: Date()),
                "updatedAt": Timestamp(date: Date())
            ]

            self.db.collection("products").document(product.id.uuidString).setData(productData) { error in
                if let error = error {
                    print("❌ Error guardando \(product.name): \(error.localizedDescription)")
                } else {
                    print("✅ Guardado: \(product.name)")
                    uploadedCount += 1
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            print("📊 Carga completada: \(uploadedCount)/\(products.count) productos guardados")
            completion(uploadedCount == products.count)
        }
    }

    // MARK: - Cargar productos desde Firebase
    func fetchProductsFromFirebase(completion: @escaping ([SeedProduct]?) -> Void) {
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error obteniendo productos: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let documents = snapshot?.documents else {
                print("❌ No hay documentos")
                completion(nil)
                return
            }

            var products: [SeedProduct] = []

            for document in documents {
                let data = document.data()

                guard let name = data["name"] as? String,
                      let price = data["price"] as? Double,
                      let category = data["category"] as? String,
                      let imageName = data["imageName"] as? String,
                      let additionalImages = data["additionalImages"] as? [String],
                      let productDescription = data["productDescription"] as? String else {
                    print("⚠️ Producto incompleto, saltando...")
                    continue
                }

                // ✅ Parsear colores — fallback: array vacío (no allColors)
                var colorOptions: [ColorOption] = []
                if let colorsData = data["colorOptions"] as? [[String: Any]] {
                    colorOptions = colorsData.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let hexColor = dict["hexColor"] as? String else { return nil }
                        return ColorOption(name: name, hexColor: hexColor)
                    }
                }

                // ✅ Parsear capacidades — fallback: array vacío (no allStorages)
                var storageOptions: [StorageOption] = []
                if let storagesData = data["storageOptions"] as? [[String: Any]] {
                    storageOptions = storagesData.compactMap { dict in
                        guard let capacity = dict["capacity"] as? String,
                              let priceMultiplier = dict["priceMultiplier"] as? Double else { return nil }
                        return StorageOption(capacity: capacity, priceMultiplier: priceMultiplier)
                    }
                }

                let product = SeedProduct(
                    name: name,
                    price: price,
                    category: category,
                    imageName: imageName,
                    additionalImages: additionalImages,
                    productDescription: productDescription,
                    colorOptions: colorOptions,
                    storageOptions: storageOptions,
                    stock:       data["stock"]       as? Int    ?? 50,
                    rating:      data["rating"]      as? Double ?? 4.5,
                    reviewCount: data["reviewCount"] as? Int    ?? 0,
                    isOnSale:    data["isOnSale"]    as? Bool   ?? false,
                    discount:    data["discount"]    as? Int    ?? 0,
                    inStock:     data["inStock"]     as? Bool   ?? true
                )

                products.append(product)
            }

            print("✅ Obtenidos \(products.count) productos desde Firebase")
            completion(products)
        }
    }

    // MARK: - Verificar si hay productos en Firebase
    func checkIfProductsExist(completion: @escaping (Bool) -> Void) {
        db.collection("products").limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error verificando productos: \(error.localizedDescription)")
                completion(false)
                return
            }
            let exists = !(snapshot?.documents.isEmpty ?? true)
            print("🔍 Productos en Firebase: \(exists ? "SÍ" : "NO")")
            completion(exists)
        }
    }

    // MARK: - Eliminar todos los productos
    func deleteAllProducts(completion: @escaping (Bool) -> Void) {
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error eliminando productos: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let documents = snapshot?.documents else { completion(true); return }

            let batch = self.db.batch()
            documents.forEach { batch.deleteDocument($0.reference) }

            batch.commit { error in
                if let error = error {
                    print("❌ Error en batch delete: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("✅ Todos los productos eliminados")
                    completion(true)
                }
            }
        }
    }

    // MARK: - Actualizar precio
    func updateProductPrice(productId: String, newPrice: Double, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "price": newPrice, "updatedAt": Timestamp(date: Date())
        ]) { error in
            completion(error == nil)
            if let error = error { print("❌ \(error.localizedDescription)") }
            else { print("✅ Precio actualizado: \(productId)") }
        }
    }

    // MARK: - Actualizar stock
    func updateProductStock(productId: String, newStock: Int, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "stock": newStock, "inStock": newStock > 0, "updatedAt": Timestamp(date: Date())
        ]) { error in
            completion(error == nil)
            if let error = error { print("❌ \(error.localizedDescription)") }
            else { print("✅ Stock actualizado: \(newStock)") }
        }
    }

    // MARK: - Aplicar descuento
    func applyDiscount(productId: String, discountPercent: Int, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "isOnSale": true, "discount": discountPercent, "updatedAt": Timestamp(date: Date())
        ]) { error in
            completion(error == nil)
            if let error = error { print("❌ \(error.localizedDescription)") }
            else { print("✅ Descuento \(discountPercent)% aplicado") }
        }
    }

    // MARK: - Actualizar rating
    func updateProductRating(productId: String, newRating: Double, reviewCount: Int, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "rating": newRating, "reviewCount": reviewCount, "updatedAt": Timestamp(date: Date())
        ]) { error in
            completion(error == nil)
            if let error = error { print("❌ \(error.localizedDescription)") }
            else { print("✅ Rating actualizado: \(newRating) ⭐") }
        }
    }
}
