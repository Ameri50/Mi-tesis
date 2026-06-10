import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class appDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("\n" + String(repeating: "=", count: 60))
        print("🚀 INICIANDO APP DELEGATE")
        print(String(repeating: "=", count: 60) + "\n")
        
        // ✅ Fix App Check para Simulador
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
        
        // Configurar Firebase
        FirebaseApp.configure()
        print("✅ Firebase configurado correctamente\n")
        
        // Cargar productos después de 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("🔍 VERIFICANDO PRODUCTOS EN FIREBASE...\n")
            
            FirebaseProductManager.shared.checkIfProductsExist { exists in
                print("📊 ¿Existen productos? \(exists)\n")
                
                if !exists {
                    print("⏳ CARGANDO \(ProductData.products.count) PRODUCTOS...\n")
                    
                    FirebaseProductManager.shared.uploadProductsToFirebase { success in
                        if success {
                            print("\n✅ ✅ ✅ PRODUCTOS CARGADOS EXITOSAMENTE ✅ ✅ ✅\n")
                        } else {
                            print("\n❌ ERROR AL CARGAR PRODUCTOS\n")
                        }
                    }
                } else {
                    print("✅ Productos ya existen en Firebase\n")
                }
            }
        }
        
        return true
    }
}
