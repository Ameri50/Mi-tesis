import Foundation
import UIKit
import FirebaseStorage

class FirebaseImageSync: NSObject, ObservableObject {
    static let shared = FirebaseImageSync()
    
    @Published var isSyncing = false
    @Published var syncProgress = 0
    @Published var syncMessage = ""
    
    private let storageManager = FirebaseStorageManager.shared
    
    override init() {
        super.init()
        print("✅ FirebaseImageSync inicializado")
    }
    
    // MARK: - Sincronizar todas las imágenes de productos
    func syncAllProductImages(completion: @escaping (Bool) -> Void) {
        guard !isSyncing else { return }
        
        isSyncing = true
        syncProgress = 0
        syncMessage = "Iniciando sincronización de imágenes..."
        
        print("🟡 Iniciando sincronización de imágenes a Firebase Storage...")
        
        let imageNames = getAllProductImageNames()
        let totalImages = imageNames.count
        
        print("📊 Total de imágenes a sincronizar: \(totalImages)")
        
        var uploadedCount = 0
        
        for imageName in imageNames {
            uploadImageFromAssets(imageName) { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    uploadedCount += 1
                    self.syncProgress = Int((Double(uploadedCount) / Double(totalImages)) * 100)
                    self.syncMessage = "Sincronizando: \(uploadedCount)/\(totalImages) imágenes"
                    print("✅ Imagen \(uploadedCount)/\(totalImages) sincronizada: \(imageName)")
                }
                
                // Si es la última imagen
                if uploadedCount == totalImages {
                    self.isSyncing = false
                    self.syncMessage = "✅ ¡Sincronización completada!"
                    print("🎉 ¡Todas las imágenes sincronizadas correctamente!")
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Subir imagen desde Assets
    private func uploadImageFromAssets(
        _ imageName: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let uiImage = UIImage(named: imageName) else {
            print("⚠️ Imagen no encontrada en Assets: \(imageName)")
            completion(false)
            return
        }
        
        storageManager.uploadImage(uiImage, fileName: imageName) { result in
            switch result {
            case .success(let url):
                print("✅ URL guardada: \(url)")
                completion(true)
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    // MARK: - Lista de todas las imágenes de productos
    private func getAllProductImageNames() -> [String] {
        return [
            // iPads
            "ipad", "ipad01",
            
            // iPhones
            "iphone1", "iphone2", "iphone3",
            
            // Macs
            "macbook", "macbook2", "macbook3", "desktopcomputer", "imac",
            
            // Apple Watch
            "applewatch",
            
            // Accesorios
            "airpodspro", "airpods", "keyboard", "mouse", "Applicon", "auri"
        ]
    }
}
