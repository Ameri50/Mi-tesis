import Foundation
import UIKit
import FirebaseStorage

@MainActor
class FirebaseImageUploader: ObservableObject {
    static let shared = FirebaseImageUploader()
    
    @Published var uploadProgress: Double = 0.0
    @Published var currentImageName: String = ""
    @Published var isUploading: Bool = false
    
    private let storage = Storage.storage()
    
    // Lista de imágenes a subir
    private let imageNames = [
        "ipad", "ipad01", "iphone1", "iphone2", "iphone3",
        "macbook", "macbook2", "macbook3", "imac", "desktopcomputer",
        "applewatch", "airpodspro", "airpods", "keyboard", "mouse",
        "Applicon", "auri"
    ]
    
    // MARK: - Upload All Images and Update Firestore
    func uploadAllImagesAndUpdateProducts(completion: @escaping (Bool) -> Void) {
        guard !isUploading else {
            print("⚠️ Ya hay una carga en progreso")
            completion(false)
            return
        }
        
        isUploading = true
        uploadProgress = 0.0
        
        print("🟡 Iniciando carga de imágenes a Firebase Storage...")
        print("📊 Total de imágenes: \(imageNames.count)")

        guard !imageNames.isEmpty else {
            isUploading = false
            uploadProgress = 1.0
            completion(true)
            return
        }
        
        let group = DispatchGroup()
        var successCount = 0
        for (index, imageName) in imageNames.enumerated() {
            group.enter()
            
            uploadImageToStorage(imageName: imageName) { url in
                if url != nil {
                    successCount += 1
                    print("✅ Imagen \(index + 1)/\(self.imageNames.count) subida: \(imageName)")
                } else {
                    print("❌ Error subiendo imagen \(index + 1)/\(self.imageNames.count): \(imageName)")
                }
                
                DispatchQueue.main.async {
                    let progress = Double(index + 1) / Double(self.imageNames.count)
                    self.uploadProgress = min(max(progress, 0), 1)
                    self.currentImageName = imageName
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isUploading = false
            self.uploadProgress = 1.0
            
            print("🎉 Carga completada: \(successCount)/\(self.imageNames.count) imágenes")
            
            // Las imágenes se mantienen en Storage; Firestore no recibe sus URLs.
            completion(successCount == self.imageNames.count)
        }
    }
    
    // MARK: - Upload Single Image
    private func uploadImageToStorage(imageName: String, completion: @escaping (String?) -> Void) {
        // Obtener imagen de Assets
        guard let image = UIImage(named: imageName) else {
            print("❌ Imagen '\(imageName)' no encontrada en Assets")
            completion(nil)
            return
        }
        
        // Convertir a PNG data
        guard let imageData = image.pngData() else {
            print("❌ Error convirtiendo imagen '\(imageName)' a PNG")
            completion(nil)
            return
        }
        
        // Referencia en Storage
        let storageRef = storage.reference().child("products/\(imageName).png")
        
        // Metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        // Subir
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("❌ Error subiendo '\(imageName)': \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Obtener URL de descarga
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("❌ Error obteniendo URL de '\(imageName)': \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(url?.absoluteString)
            }
        }
    }
    
    // MARK: - Delete All Images from Storage (Utility)
    func deleteAllImagesFromStorage(completion: @escaping (Bool) -> Void) {
        print("🗑️ Eliminando todas las imágenes de Storage...")
        
        let storageRef = storage.reference().child("products")
        let group = DispatchGroup()
        
        for imageName in imageNames {
            group.enter()
            
            let imageRef = storageRef.child("\(imageName).png")
            imageRef.delete { error in
                if let error = error {
                    print("❌ Error eliminando '\(imageName)': \(error.localizedDescription)")
                } else {
                    print("✅ Imagen eliminada: \(imageName)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("🎉 Proceso de eliminación completado")
            completion(true)
        }
    }
}
