import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAppCheck

// MARK: - Firebase Order Manager - SOLO GUARDAR EN FIREBASE
class FirebaseOrderManager: NSObject, ObservableObject {
    static let shared = FirebaseOrderManager()
    
    private let db = Firestore.firestore()
    private let ordersCollection = "orders"
    
    override init() {
        super.init()
        
        print("✅ FirebaseOrderManager inicializado")
        print("📍 Modo: Solo guardar órdenes en Firebase")
        
        // ✅ DESHABILITAR APP CHECK PARA DESARROLLO
        #if DEBUG
            let debugProvider = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(debugProvider)
            print("🔓 App Check deshabilitado para DEBUG")
        #endif
        
        // Configurar Firestore para usar caché offline
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        db.settings = settings
    }
    
    // MARK: - Guardar Orden en Firebase SOLAMENTE
    func saveOrder(cartItems: [CartItem], total: Double, paymentMethod: String, completion: @escaping (Bool) -> Void) {
        print("🟡 saveOrder() iniciada")
        print("💰 total: S/. \(total)")
        print("📦 items: \(cartItems.count) productos")
        print("💳 método de pago: \(paymentMethod)")
        
        // Convertir CartItem a diccionario
        let orderItems = cartItems.map { item in
            [
                "product_id": item.product.id.uuidString,
                "product_name": item.product.name,
                "quantity": item.quantity,
                "price": item.product.price
            ] as [String: Any]
        }
        
        let orderData: [String: Any] = [
            "total": total,
            "status": "completado",
            "payment_method": paymentMethod,
            "created_at": Timestamp(date: Date()),
            "items": orderItems
        ]
        
        print("📤 Guardando orden en Firebase Firestore...")
        
        // Guardar en Firestore
        db.collection(ordersCollection).addDocument(data: orderData) { [weak self] error in
            guard self != nil else { return }
            
            if let error = error {
                print("❌ Error al guardar la orden: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ ¡Orden guardada exitosamente en Firebase!")
                print("📊 Verifica en Firebase Console → Firestore → orders")
                completion(true)
            }
        }
    }
}
