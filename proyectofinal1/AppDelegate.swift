import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class appDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

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

        // ✅ Solo sube productos si Firebase está vacío (seed automático)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FirebaseProductManager.shared.checkIfProductsExist { exists in
                if exists {
                    print("ℹ️  Firebase ya tiene productos, no se necesita seed.\n")
                } else {
                    print("📭 Firebase vacío — subiendo \(ProductData.products.count) productos...\n")
                    FirebaseProductManager.shared.uploadProductsToFirebase { success in
                        if success {
                            print("✅ Seed completado: \(ProductData.products.count) productos subidos.\n")
                        } else {
                            print("❌ Error durante el seed de productos.\n")
                        }
                    }
                }
            }
        }

        return true
    }
}
