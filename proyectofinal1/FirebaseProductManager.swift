import Foundation
import FirebaseFirestore

class FirebaseProductManager {
    static let shared = FirebaseProductManager()
    private let db = Firestore.firestore()
    
    // MARK: - Cargar productos a Firebase (Con nuevos campos)
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
                "colorOptions": product.colorOptions.map { color in
                    [
                        "name": color.name,
                        "hexColor": color.hexColor
                    ]
                },
                "storageOptions": product.storageOptions.map { storage in
                    [
                        "capacity": storage.capacity,
                        "priceMultiplier": storage.priceMultiplier
                    ]
                },
                // 🆕 NUEVOS CAMPOS
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
    
    // MARK: - Cargar productos desde Firebase (Con nuevos campos)
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
                
                // Campos requeridos (si faltan, saltar este producto)
                guard let name = data["name"] as? String,
                      let price = data["price"] as? Double,
                      let category = data["category"] as? String,
                      let imageName = data["imageName"] as? String,
                      let additionalImages = data["additionalImages"] as? [String],
                      let productDescription = data["productDescription"] as? String else {
                    print("⚠️ Producto incompleto, saltando...")
                    continue
                }
                
                // Parsear colores
                var colorOptions: [ColorOption] = ColorOption.allColors
                if let colorsData = data["colorOptions"] as? [[String: Any]] {
                    colorOptions = colorsData.compactMap { colorDict in
                        guard let name = colorDict["name"] as? String,
                              let hexColor = colorDict["hexColor"] as? String else {
                            return nil
                        }
                        return ColorOption(name: name, hexColor: hexColor)
                    }
                }
                
                // Parsear capacidades
                var storageOptions: [StorageOption] = StorageOption.allStorages
                if let storagesData = data["storageOptions"] as? [[String: Any]] {
                    storageOptions = storagesData.compactMap { storageDict in
                        guard let capacity = storageDict["capacity"] as? String,
                              let priceMultiplier = storageDict["priceMultiplier"] as? Double else {
                            return nil
                        }
                        return StorageOption(capacity: capacity, priceMultiplier: priceMultiplier)
                    }
                }
                
                // 🆕 Obtener nuevos campos con valores por defecto
                let stock = data["stock"] as? Int ?? 50
                let rating = data["rating"] as? Double ?? 4.5
                let reviewCount = data["reviewCount"] as? Int ?? 0
                let isOnSale = data["isOnSale"] as? Bool ?? false
                let discount = data["discount"] as? Int ?? 0
                let inStock = data["inStock"] as? Bool ?? true
                
                let product = SeedProduct(
                    name: name,
                    price: price,
                    category: category,
                    imageName: imageName,
                    additionalImages: additionalImages,
                    productDescription: productDescription,
                    colorOptions: colorOptions,
                    storageOptions: storageOptions,
                    // 🆕 Pasar nuevos campos
                    stock: stock,
                    rating: rating,
                    reviewCount: reviewCount,
                    isOnSale: isOnSale,
                    discount: discount,
                    inStock: inStock
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
    
    // MARK: - Limpiar todos los productos
    func deleteAllProducts(completion: @escaping (Bool) -> Void) {
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error eliminando productos: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(true)
                return
            }
            
            let batch = self.db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
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
    
    // 🆕 MARCA: - Actualizar precio de un producto
    func updateProductPrice(productId: String, newPrice: Double, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "price": newPrice,
            "updatedAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("❌ Error actualizando precio: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Precio actualizado para producto: \(productId)")
                completion(true)
            }
        }
    }
    
    // 🆕 MARCA: - Actualizar stock de un producto
    func updateProductStock(productId: String, newStock: Int, completion: @escaping (Bool) -> Void) {
        let inStock = newStock > 0
        db.collection("products").document(productId).updateData([
            "stock": newStock,
            "inStock": inStock,
            "updatedAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("❌ Error actualizando stock: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Stock actualizado: \(newStock) unidades")
                completion(true)
            }
        }
    }
    
    // 🆕 MARCA: - Aplicar descuento a un producto
    func applyDiscount(productId: String, discountPercent: Int, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "isOnSale": true,
            "discount": discountPercent,
            "updatedAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("❌ Error aplicando descuento: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Descuento de \(discountPercent)% aplicado")
                completion(true)
            }
        }
    }
    
    // 🆕 MARCA: - Actualizar rating de un producto
    func updateProductRating(productId: String, newRating: Double, reviewCount: Int, completion: @escaping (Bool) -> Void) {
        db.collection("products").document(productId).updateData([
            "rating": newRating,
            "reviewCount": reviewCount,
            "updatedAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("❌ Error actualizando rating: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Rating actualizado: \(newRating) ⭐")
                completion(true)
            }
        }
    }
}
