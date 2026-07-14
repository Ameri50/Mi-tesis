import Foundation
import FirebaseFirestore
import SwiftUI

// MARK: - Modelo para Firestore
struct FirebaseProduct: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var price: Double
    var category: String
    var imageName: String
    var description: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, category, imageName, description
    }
}

// MARK: - Firebase Product Sync Manager
@MainActor
class FirebaseProductSync: NSObject, ObservableObject {
    static let shared = FirebaseProductSync()
    
    @Published var isSyncing = false
    @Published var syncProgress = 0
    @Published var syncMessage = ""
    
    private let db = Firestore.firestore()
    private let productsCollection = "products"
    
    // MARK: - Sincronizar todos los productos
    func syncAllProducts(completion: @escaping (Bool) -> Void) {
        guard !isSyncing else { return }
        
        isSyncing = true
        syncProgress = 0
        syncMessage = "Iniciando sincronización..."
        
        print("🟡 Iniciando sincronización de productos a Firebase...")
        
        let allProducts = getAllProducts()
        let totalProducts = allProducts.count
        
        print("📊 Total de productos a sincronizar: \(totalProducts)")
        
        var uploadedCount = 0
        
        for (_, product) in allProducts.enumerated() {
            uploadProduct(product) { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    uploadedCount += 1
                    self.syncProgress = Int((Double(uploadedCount) / Double(totalProducts)) * 100)
                    self.syncMessage = "Sincronizando: \(uploadedCount)/\(totalProducts) productos"
                    print("✅ Producto \(uploadedCount)/\(totalProducts) sincronizado")
                }
                
                // Si es el último producto
                if uploadedCount == totalProducts {
                    self.isSyncing = false
                    self.syncMessage = "✅ ¡Sincronización completada!"
                    print("🎉 ¡Todos los productos sincronizados correctamente!")
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Subir un producto individual
    private func uploadProduct(_ product: FirebaseProduct, completion: @escaping (Bool) -> Void) {
        let productData: [String: Any] = [
            "name": product.name,
            "price": product.price,
            "category": product.category,
            "imageName": product.imageName,
            "description": product.description
        ]
        
        db.collection(productsCollection).addDocument(data: productData) { error in
            if let error = error {
                print("❌ Error subiendo producto \(product.name): \(error)")
                completion(false)
            } else {
                print("✅ Producto \(product.name) subido")
                completion(true)
            }
        }
    }
    
    // MARK: - Obtener todos los productos
    private func getAllProducts() -> [FirebaseProduct] {
        return [
            // iPad - 35 productos
            FirebaseProduct(name: "iPad Pro 12.9\" M2", price: 1099.00, category: "iPad", imageName: "ipad", description: "Tablet potente con chip M2"),
            FirebaseProduct(name: "iPad Pro 11\" M2", price: 899.00, category: "iPad", imageName: "ipad01", description: "iPad Pro 11 pulgadas"),
            FirebaseProduct(name: "iPad Air 11\" M1", price: 799.00, category: "iPad", imageName: "ipad", description: "Tablet versátil"),
            FirebaseProduct(name: "iPad Air 13\" M1", price: 999.00, category: "iPad", imageName: "ipad01", description: "iPad Air 13 pulgadas"),
            FirebaseProduct(name: "iPad 10.9\" 10ma Gen", price: 349.00, category: "iPad", imageName: "ipad", description: "iPad estándar"),
            FirebaseProduct(name: "iPad Mini 7", price: 499.00, category: "iPad", imageName: "ipad01", description: "Tablet compacta"),
            FirebaseProduct(name: "iPad Pro 12.9\" M4", price: 1299.00, category: "iPad", imageName: "ipad", description: "iPad Pro última generación"),
            FirebaseProduct(name: "iPad Air 11\" M2", price: 849.00, category: "iPad", imageName: "ipad01", description: "iPad Air M2"),
            FirebaseProduct(name: "iPad 10.2\" 9na Gen", price: 329.00, category: "iPad", imageName: "ipad", description: "iPad básico"),
            FirebaseProduct(name: "iPad Mini 6 256GB", price: 549.00, category: "iPad", imageName: "ipad01", description: "iPad Mini con 256GB"),
            FirebaseProduct(name: "iPad Pro 11\" M4", price: 1099.00, category: "iPad", imageName: "ipad", description: "iPad Pro 11 M4"),
            FirebaseProduct(name: "iPad Air 13\" M2", price: 1049.00, category: "iPad", imageName: "ipad01", description: "iPad Air 13 M2"),
            FirebaseProduct(name: "iPad 10.9\" WiFi 64GB", price: 349.00, category: "iPad", imageName: "ipad", description: "iPad WiFi"),
            FirebaseProduct(name: "iPad Mini 5 128GB", price: 479.00, category: "iPad", imageName: "ipad01", description: "iPad Mini 5"),
            FirebaseProduct(name: "iPad Pro 12.9\" Space Gray", price: 1199.00, category: "iPad", imageName: "ipad", description: "iPad Pro Space Gray"),
            FirebaseProduct(name: "iPad Air Rose Gold", price: 749.00, category: "iPad", imageName: "ipad01", description: "iPad Air Rose Gold"),
            FirebaseProduct(name: "iPad 10.9\" Silver", price: 379.00, category: "iPad", imageName: "ipad", description: "iPad Silver"),
            FirebaseProduct(name: "iPad Mini Gold", price: 529.00, category: "iPad", imageName: "ipad01", description: "iPad Mini Gold"),
            FirebaseProduct(name: "iPad Pro 11\" LTE", price: 1049.00, category: "iPad", imageName: "ipad", description: "iPad Pro LTE"),
            FirebaseProduct(name: "iPad Air WiFi 256GB", price: 899.00, category: "iPad", imageName: "ipad01", description: "iPad Air WiFi"),
            FirebaseProduct(name: "iPad 10.9\" Gris", price: 349.00, category: "iPad", imageName: "ipad", description: "iPad Gris"),
            FirebaseProduct(name: "iPad Mini Purple", price: 499.00, category: "iPad", imageName: "ipad01", description: "iPad Mini Purple"),
            FirebaseProduct(name: "iPad Pro 12.9\" LTE", price: 1349.00, category: "iPad", imageName: "ipad", description: "iPad Pro LTE"),
            FirebaseProduct(name: "iPad Air Blue", price: 799.00, category: "iPad", imageName: "ipad01", description: "iPad Air Blue"),
            FirebaseProduct(name: "iPad 10.9\" Blue", price: 359.00, category: "iPad", imageName: "ipad", description: "iPad Blue"),
            FirebaseProduct(name: "iPad Mini Starlight", price: 519.00, category: "iPad", imageName: "ipad01", description: "iPad Mini Starlight"),
            FirebaseProduct(name: "iPad Pro 11\" Space Black", price: 1099.00, category: "iPad", imageName: "ipad", description: "iPad Pro Space Black"),
            FirebaseProduct(name: "iPad Air 13\" Purple", price: 1049.00, category: "iPad", imageName: "ipad01", description: "iPad Air Purple"),
            FirebaseProduct(name: "iPad 10.9\" Yellow", price: 369.00, category: "iPad", imageName: "ipad", description: "iPad Yellow"),
            FirebaseProduct(name: "iPad Mini Orange", price: 489.00, category: "iPad", imageName: "ipad01", description: "iPad Mini Orange"),
            FirebaseProduct(name: "iPad Pro 12.9\" 1TB", price: 1599.00, category: "iPad", imageName: "ipad", description: "iPad Pro 1TB"),
            FirebaseProduct(name: "iPad Air 11\" 512GB", price: 949.00, category: "iPad", imageName: "ipad01", description: "iPad Air 512GB"),
            FirebaseProduct(name: "iPad 10.9\" 256GB", price: 429.00, category: "iPad", imageName: "ipad", description: "iPad 256GB"),
            FirebaseProduct(name: "iPad Mini 128GB Green", price: 539.00, category: "iPad", imageName: "ipad01", description: "iPad Mini Green"),
            FirebaseProduct(name: "iPad Pro 11\" 512GB", price: 1199.00, category: "iPad", imageName: "ipad", description: "iPad Pro 512GB"),
            
            // iPhone - 35 productos
            FirebaseProduct(name: "iPhone 15 Pro Max 256GB", price: 1199.00, category: "iPhone", imageName: "iphone1", description: "iPhone última generación"),
            FirebaseProduct(name: "iPhone 15 Pro 256GB", price: 999.00, category: "iPhone", imageName: "iphone2", description: "iPhone Pro"),
            FirebaseProduct(name: "iPhone 15 256GB", price: 799.00, category: "iPhone", imageName: "iphone3", description: "iPhone 15"),
            FirebaseProduct(name: "iPhone 15 Plus 256GB", price: 899.00, category: "iPhone", imageName: "iphone1", description: "iPhone 15 Plus"),
            FirebaseProduct(name: "iPhone 15 Pro Max 512GB", price: 1299.00, category: "iPhone", imageName: "iphone2", description: "iPhone Pro Max 512GB"),
            FirebaseProduct(name: "iPhone 15 Pro 512GB", price: 1099.00, category: "iPhone", imageName: "iphone3", description: "iPhone Pro 512GB"),
            FirebaseProduct(name: "iPhone 15 512GB", price: 899.00, category: "iPhone", imageName: "iphone1", description: "iPhone 15 512GB"),
            FirebaseProduct(name: "iPhone 15 Plus 512GB", price: 999.00, category: "iPhone", imageName: "iphone2", description: "iPhone 15 Plus 512GB"),
            FirebaseProduct(name: "iPhone 15 Pro Max 1TB", price: 1399.00, category: "iPhone", imageName: "iphone3", description: "iPhone Pro Max 1TB"),
            FirebaseProduct(name: "iPhone 15 Pro 1TB", price: 1199.00, category: "iPhone", imageName: "iphone1", description: "iPhone Pro 1TB"),
            FirebaseProduct(name: "iPhone 15 Black", price: 799.00, category: "iPhone", imageName: "iphone2", description: "iPhone 15 Black"),
            FirebaseProduct(name: "iPhone 15 White", price: 799.00, category: "iPhone", imageName: "iphone3", description: "iPhone 15 White"),
            FirebaseProduct(name: "iPhone 15 Blue", price: 799.00, category: "iPhone", imageName: "iphone1", description: "iPhone 15 Blue"),
            FirebaseProduct(name: "iPhone 15 Green", price: 799.00, category: "iPhone", imageName: "iphone2", description: "iPhone 15 Green"),
            FirebaseProduct(name: "iPhone 15 Yellow", price: 799.00, category: "iPhone", imageName: "iphone3", description: "iPhone 15 Yellow"),
            FirebaseProduct(name: "iPhone 15 Pro Max Titanio", price: 1199.00, category: "iPhone", imageName: "iphone1", description: "iPhone Pro Max Titanio"),
            FirebaseProduct(name: "iPhone 15 Pro Black", price: 999.00, category: "iPhone", imageName: "iphone2", description: "iPhone Pro Black"),
            FirebaseProduct(name: "iPhone 15 Pro White", price: 999.00, category: "iPhone", imageName: "iphone3", description: "iPhone Pro White"),
            FirebaseProduct(name: "iPhone 15 Pro Blue", price: 999.00, category: "iPhone", imageName: "iphone1", description: "iPhone Pro Blue"),
            FirebaseProduct(name: "iPhone 15 Pro Gold", price: 999.00, category: "iPhone", imageName: "iphone2", description: "iPhone Pro Gold"),
            FirebaseProduct(name: "iPhone 15 Plus Black", price: 899.00, category: "iPhone", imageName: "iphone3", description: "iPhone 15 Plus Black"),
            FirebaseProduct(name: "iPhone 15 Plus White", price: 899.00, category: "iPhone", imageName: "iphone1", description: "iPhone 15 Plus White"),
            FirebaseProduct(name: "iPhone 15 Plus Blue", price: 899.00, category: "iPhone", imageName: "iphone2", description: "iPhone 15 Plus Blue"),
            FirebaseProduct(name: "iPhone 15 Plus Green", price: 899.00, category: "iPhone", imageName: "iphone3", description: "iPhone 15 Plus Green"),
            FirebaseProduct(name: "iPhone 15 Plus Red", price: 899.00, category: "iPhone", imageName: "iphone1", description: "iPhone 15 Plus Red"),
            FirebaseProduct(name: "iPhone 14 Pro Max", price: 1099.00, category: "iPhone", imageName: "iphone2", description: "iPhone 14 Pro Max"),
            FirebaseProduct(name: "iPhone 14 Pro", price: 899.00, category: "iPhone", imageName: "iphone3", description: "iPhone 14 Pro"),
            FirebaseProduct(name: "iPhone 14 Plus", price: 799.00, category: "iPhone", imageName: "iphone1", description: "iPhone 14 Plus"),
            FirebaseProduct(name: "iPhone 14", price: 699.00, category: "iPhone", imageName: "iphone2", description: "iPhone 14"),
            FirebaseProduct(name: "iPhone 13 Pro Max", price: 999.00, category: "iPhone", imageName: "iphone3", description: "iPhone 13 Pro Max"),
            FirebaseProduct(name: "iPhone 13 Pro", price: 799.00, category: "iPhone", imageName: "iphone1", description: "iPhone 13 Pro"),
            FirebaseProduct(name: "iPhone 13", price: 599.00, category: "iPhone", imageName: "iphone2", description: "iPhone 13"),
            FirebaseProduct(name: "iPhone SE 3", price: 429.00, category: "iPhone", imageName: "iphone3", description: "iPhone SE"),
            FirebaseProduct(name: "iPhone 15 Pro Max Space Black", price: 1199.00, category: "iPhone", imageName: "iphone1", description: "iPhone Pro Max Space Black"),
            FirebaseProduct(name: "iPhone 15 Pro Desert Titanio", price: 999.00, category: "iPhone", imageName: "iphone2", description: "iPhone Pro Desert Titanio"),
            
            // Mac - 35 productos
            FirebaseProduct(name: "MacBook Pro 16\" M3 Max", price: 3499.00, category: "Mac", imageName: "macbook", description: "MacBook Pro 16 M3 Max"),
            FirebaseProduct(name: "MacBook Pro 14\" M3 Max", price: 2999.00, category: "Mac", imageName: "macbook2", description: "MacBook Pro 14 M3 Max"),
            FirebaseProduct(name: "MacBook Pro 14\" M3", price: 1999.00, category: "Mac", imageName: "macbook3", description: "MacBook Pro 14 M3"),
            FirebaseProduct(name: "MacBook Air 15\" M2", price: 1799.00, category: "Mac", imageName: "macbook", description: "MacBook Air 15 M2"),
            FirebaseProduct(name: "MacBook Air 13\" M2", price: 1199.00, category: "Mac", imageName: "macbook2", description: "MacBook Air 13 M2"),
            FirebaseProduct(name: "Mac Mini M2", price: 699.00, category: "Mac", imageName: "desktopcomputer", description: "Mac Mini M2"),
            FirebaseProduct(name: "iMac 24\" M3", price: 1599.00, category: "Mac", imageName: "imac", description: "iMac 24 M3"),
            FirebaseProduct(name: "Mac Studio M2 Max", price: 3999.00, category: "Mac", imageName: "macbook", description: "Mac Studio M2 Max"),
            FirebaseProduct(name: "Mac Pro M2 Ultra", price: 7999.00, category: "Mac", imageName: "macbook2", description: "Mac Pro M2 Ultra"),
            FirebaseProduct(name: "MacBook Pro 16\" M2 Max", price: 2499.00, category: "Mac", imageName: "macbook3", description: "MacBook Pro 16 M2 Max"),
            FirebaseProduct(name: "MacBook Pro 14\" M2 Pro", price: 1999.00, category: "Mac", imageName: "macbook", description: "MacBook Pro 14 M2 Pro"),
            FirebaseProduct(name: "MacBook Air 15\" M1", price: 1599.00, category: "Mac", imageName: "macbook2", description: "MacBook Air 15 M1"),
            FirebaseProduct(name: "MacBook Air 13\" M1", price: 999.00, category: "Mac", imageName: "macbook3", description: "MacBook Air 13 M1"),
            FirebaseProduct(name: "Mac Mini M1", price: 599.00, category: "Mac", imageName: "desktopcomputer", description: "Mac Mini M1"),
            FirebaseProduct(name: "iMac 24\" M1", price: 1399.00, category: "Mac", imageName: "imac", description: "iMac 24 M1"),
            FirebaseProduct(name: "MacBook Pro 16\" Silver", price: 2499.00, category: "Mac", imageName: "macbook", description: "MacBook Pro Silver"),
            FirebaseProduct(name: "MacBook Pro 14\" Space Black", price: 1999.00, category: "Mac", imageName: "macbook2", description: "MacBook Pro Space Black"),
            FirebaseProduct(name: "MacBook Air Space Gray", price: 1199.00, category: "Mac", imageName: "macbook3", description: "MacBook Air Space Gray"),
            FirebaseProduct(name: "Mac Mini Gold", price: 699.00, category: "Mac", imageName: "desktopcomputer", description: "Mac Mini Gold"),
            FirebaseProduct(name: "iMac Blue", price: 1599.00, category: "Mac", imageName: "imac", description: "iMac Blue"),
            FirebaseProduct(name: "MacBook Pro 16\" 512GB", price: 2699.00, category: "Mac", imageName: "macbook", description: "MacBook Pro 512GB"),
            FirebaseProduct(name: "MacBook Pro 14\" 1TB", price: 2199.00, category: "Mac", imageName: "macbook2", description: "MacBook Pro 1TB"),
            FirebaseProduct(name: "MacBook Air 15\" 512GB", price: 1399.00, category: "Mac", imageName: "macbook3", description: "MacBook Air 512GB"),
            FirebaseProduct(name: "Mac Mini 512GB", price: 799.00, category: "Mac", imageName: "desktopcomputer", description: "Mac Mini 512GB"),
            FirebaseProduct(name: "iMac 1TB", price: 1799.00, category: "Mac", imageName: "imac", description: "iMac 1TB"),
            FirebaseProduct(name: "Mac Studio M1 Max", price: 2999.00, category: "Mac", imageName: "macbook", description: "Mac Studio M1 Max"),
            FirebaseProduct(name: "Mac Pro M1 Ultra", price: 6999.00, category: "Mac", imageName: "macbook2", description: "Mac Pro M1 Ultra"),
            FirebaseProduct(name: "MacBook Pro 16\" M3 Base", price: 2499.00, category: "Mac", imageName: "macbook3", description: "MacBook Pro M3 Base"),
            FirebaseProduct(name: "MacBook Air 13\" M3", price: 1399.00, category: "Mac", imageName: "macbook", description: "MacBook Air M3"),
            FirebaseProduct(name: "Mac Mini M3", price: 799.00, category: "Mac", imageName: "desktopcomputer", description: "Mac Mini M3"),
            FirebaseProduct(name: "iMac 27\" 5K", price: 1999.00, category: "Mac", imageName: "imac", description: "iMac 27 5K"),
            FirebaseProduct(name: "MacBook Pro 14\" M3 Pro", price: 1999.00, category: "Mac", imageName: "macbook", description: "MacBook Pro M3 Pro"),
            FirebaseProduct(name: "MacBook Air 15\" M3", price: 1899.00, category: "Mac", imageName: "macbook2", description: "MacBook Air M3"),
            FirebaseProduct(name: "Mac Studio M2 Ultra", price: 5999.00, category: "Mac", imageName: "macbook3", description: "Mac Studio M2 Ultra"),
            FirebaseProduct(name: "Mac Mini Purple", price: 699.00, category: "Mac", imageName: "desktopcomputer", description: "Mac Mini Purple"),
            
            // Apple Watch - 35 productos
            FirebaseProduct(name: "Apple Watch Series 9 45mm", price: 429.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 9"),
            FirebaseProduct(name: "Apple Watch Series 9 41mm", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 9 41mm"),
            FirebaseProduct(name: "Apple Watch Ultra 2", price: 899.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Ultra 2"),
            FirebaseProduct(name: "Apple Watch Ultra", price: 799.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Ultra"),
            FirebaseProduct(name: "Apple Watch SE 3", price: 249.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE 3"),
            FirebaseProduct(name: "Apple Watch SE 2", price: 229.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE 2"),
            FirebaseProduct(name: "Apple Watch Series 8 45mm", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 8"),
            FirebaseProduct(name: "Apple Watch Series 8 41mm", price: 369.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 8 41mm"),
            FirebaseProduct(name: "Apple Watch Series 7 45mm", price: 329.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 7"),
            FirebaseProduct(name: "Apple Watch Series 7 41mm", price: 299.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 7 41mm"),
            FirebaseProduct(name: "Apple Watch Series 9 Aluminum", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Aluminum"),
            FirebaseProduct(name: "Apple Watch Series 9 Stainless", price: 499.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Stainless"),
            FirebaseProduct(name: "Apple Watch Series 9 Titanio", price: 599.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Titanio"),
            FirebaseProduct(name: "Apple Watch Ultra 2 Titanio", price: 899.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Ultra Titanio"),
            FirebaseProduct(name: "Apple Watch SE 3 Aluminum", price: 249.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE Aluminum"),
            FirebaseProduct(name: "Apple Watch Series 9 Rose Gold", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Rose Gold"),
            FirebaseProduct(name: "Apple Watch Series 9 Gold", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Gold"),
            FirebaseProduct(name: "Apple Watch Series 9 Silver", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Silver"),
            FirebaseProduct(name: "Apple Watch Series 9 Black", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Black"),
            FirebaseProduct(name: "Apple Watch Ultra 2 Yellow", price: 899.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Ultra Yellow"),
            FirebaseProduct(name: "Apple Watch SE 3 Midnight", price: 249.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE Midnight"),
            FirebaseProduct(name: "Apple Watch SE 3 Starlight", price: 249.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE Starlight"),
            FirebaseProduct(name: "Apple Watch Series 8 Green", price: 369.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Green"),
            FirebaseProduct(name: "Apple Watch Series 8 Blue", price: 369.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Blue"),
            FirebaseProduct(name: "Apple Watch Series 7 Green", price: 299.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 7 Green"),
            FirebaseProduct(name: "Apple Watch Series 9 Sport Band", price: 399.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Sport Band"),
            FirebaseProduct(name: "Apple Watch Ultra 2 Ocean", price: 899.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Ultra Ocean"),
            FirebaseProduct(name: "Apple Watch SE 3 Sport", price: 249.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE Sport"),
            FirebaseProduct(name: "Apple Watch Series 9 Cellular", price: 529.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Cellular"),
            FirebaseProduct(name: "Apple Watch Ultra Cellular", price: 899.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Ultra Cellular"),
            FirebaseProduct(name: "Apple Watch Series 8 Cellular", price: 499.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 8 Cellular"),
            FirebaseProduct(name: "Apple Watch Series 7 Cellular", price: 429.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Series 7 Cellular"),
            FirebaseProduct(name: "Apple Watch Series 9 Nike", price: 429.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Nike"),
            FirebaseProduct(name: "Apple Watch Series 9 Hermès", price: 749.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch Hermès"),
            FirebaseProduct(name: "Apple Watch SE 3 GPS", price: 249.00, category: "Apple Watch", imageName: "applewatch", description: "Apple Watch SE GPS"),
            
            // Accesorios - 35 productos
            FirebaseProduct(name: "AirPods Pro 2", price: 249.00, category: "Accesorios", imageName: "airpodspro", description: "AirPods Pro 2"),
            FirebaseProduct(name: "AirPods Max", price: 549.00, category: "Accesorios", imageName: "airpods", description: "AirPods Max"),
            FirebaseProduct(name: "AirPods 3", price: 169.00, category: "Accesorios", imageName: "airpodspro", description: "AirPods 3"),
            FirebaseProduct(name: "AirPods 2", price: 129.00, category: "Accesorios", imageName: "airpods", description: "AirPods 2"),
            FirebaseProduct(name: "Magic Keyboard iPad", price: 349.00, category: "Accesorios", imageName: "keyboard", description: "Magic Keyboard"),
            FirebaseProduct(name: "Magic Mouse 2", price: 79.00, category: "Accesorios", imageName: "mouse", description: "Magic Mouse 2"),
            FirebaseProduct(name: "Magic Trackpad", price: 129.00, category: "Accesorios", imageName: "keyboard", description: "Magic Trackpad"),
            FirebaseProduct(name: "Apple Pencil Pro", price: 129.00, category: "Accesorios", imageName: "Applicon", description: "Apple Pencil Pro"),
            FirebaseProduct(name: "Apple Pencil 2", price: 119.00, category: "Accesorios", imageName: "Applicon", description: "Apple Pencil 2"),
            FirebaseProduct(name: "Apple Pencil 1", price: 99.00, category: "Accesorios", imageName: "auri", description: "Apple Pencil 1"),
            FirebaseProduct(name: "AirTag", price: 29.00, category: "Accesorios", imageName: "auri", description: "AirTag"),
            FirebaseProduct(name: "AirTag 4 Pack", price: 99.00, category: "Accesorios", imageName: "auri", description: "AirTag 4 Pack"),
            FirebaseProduct(name: "Smart Folio iPad", price: 79.00, category: "Accesorios", imageName: "keyboard", description: "Smart Folio"),
            FirebaseProduct(name: "Magic Keyboard Folio", price: 199.00, category: "Accesorios", imageName: "keyboard", description: "Magic Keyboard Folio"),
            FirebaseProduct(name: "USB-C Cable", price: 19.00, category: "Accesorios", imageName: "mouse", description: "USB-C Cable"),
            FirebaseProduct(name: "USB-C Power Adapter", price: 29.00, category: "Accesorios", imageName: "Applicon", description: "USB-C Power Adapter"),
            FirebaseProduct(name: "MagSafe Charger", price: 39.00, category: "Accesorios", imageName: "auri", description: "MagSafe Charger"),
            FirebaseProduct(name: "MagSafe Car Mount", price: 39.00, category: "Accesorios", imageName: "keyboard", description: "MagSafe Car Mount"),
            FirebaseProduct(name: "ProDisplay XDR", price: 4999.00, category: "Accesorios", imageName: "mouse", description: "ProDisplay XDR"),
            FirebaseProduct(name: "Apple Studio Display", price: 1599.00, category: "Accesorios", imageName: "Applicon", description: "Apple Studio Display"),
            FirebaseProduct(name: "LUT Cake", price: 999.00, category: "Accesorios", imageName: "auri", description: "LUT Cake"),
            FirebaseProduct(name: "VESA Mount Adapter", price: 99.00, category: "Accesorios", imageName: "keyboard", description: "VESA Mount"),
            FirebaseProduct(name: "Smart Keyboard Folio", price: 169.00, category: "Accesorios", imageName: "keyboard", description: "Smart Keyboard Folio"),
            FirebaseProduct(name: "iPad Air Case", price: 49.00, category: "Accesorios", imageName: "mouse", description: "iPad Air Case"),
            FirebaseProduct(name: "iPad Pro Case", price: 59.00, category: "Accesorios", imageName: "Applicon", description: "iPad Pro Case"),
            FirebaseProduct(name: "iPhone Silicone Case", price: 49.00, category: "Accesorios", imageName: "auri", description: "iPhone Silicone Case"),
            FirebaseProduct(name: "iPhone Leather Case", price: 59.00, category: "Accesorios", imageName: "keyboard", description: "iPhone Leather Case"),
            FirebaseProduct(name: "iPhone Clear Case", price: 39.00, category: "Accesorios", imageName: "mouse", description: "iPhone Clear Case"),
            FirebaseProduct(name: "MagSafe Wallet", price: 59.00, category: "Accesorios", imageName: "Applicon", description: "MagSafe Wallet"),
            FirebaseProduct(name: "FineWoven Wallet", price: 59.00, category: "Accesorios", imageName: "auri", description: "FineWoven Wallet"),
            FirebaseProduct(name: "Apple Watch Band", price: 49.00, category: "Accesorios", imageName: "keyboard", description: "Apple Watch Band"),
            FirebaseProduct(name: "Sport Loop", price: 49.00, category: "Accesorios", imageName: "mouse", description: "Sport Loop"),
            FirebaseProduct(name: "Leather Link", price: 99.00, category: "Accesorios", imageName: "Applicon", description: "Leather Link"),
            FirebaseProduct(name: "Hermès Band", price: 149.00, category: "Accesorios", imageName: "auri", description: "Hermès Band"),
            FirebaseProduct(name: "HomePod mini", price: 99.00, category: "Accesorios", imageName: "keyboard", description: "HomePod mini"),
        ]
    }
}
