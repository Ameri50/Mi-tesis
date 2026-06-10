import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

@MainActor
class FirebaseImageUploader: ObservableObject {
    static let shared = FirebaseImageUploader()
    
    @Published var uploadProgress: Double = 0.0
    @Published var currentImageName: String = ""
    @Published var isUploading: Bool = false
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
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
        
        let group = DispatchGroup()
        var successCount = 0
        var imageURLs: [String: String] = [:] // imageName -> URL
        
        for (index, imageName) in imageNames.enumerated() {
            group.enter()
            
            uploadImageToStorage(imageName: imageName) { url in
                if let url = url {
                    imageURLs[imageName] = url
                    successCount += 1
                    print("✅ Imagen \(index + 1)/\(self.imageNames.count) subida: \(imageName)")
                } else {
                    print("❌ Error subiendo imagen \(index + 1)/\(self.imageNames.count): \(imageName)")
                }
                
                DispatchQueue.main.async {
                    self.uploadProgress = Double(index + 1) / Double(self.imageNames.count)
                    self.currentImageName = imageName
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isUploading = false
            self.uploadProgress = 1.0
            
            print("🎉 Carga completada: \(successCount)/\(self.imageNames.count) imágenes")
            
            // Actualizar URLs en Firestore
            self.updateProductURLsInFirestore(imageURLs: imageURLs) { success in
                completion(success)
            }
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
    
    // MARK: - Update Product URLs in Firestore
    private func updateProductURLsInFirestore(imageURLs: [String: String], completion: @escaping (Bool) -> Void) {
        print("🟡 Actualizando URLs de productos en Firestore...")
        
        let productsRef = db.collection("products")
        
        productsRef.getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error obteniendo productos: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ No hay productos en Firestore")
                completion(false)
                return
            }
            
            let group = DispatchGroup()
            var updateCount = 0
            
            for document in documents {
                let data = document.data()
                guard let imageName = data["imageName"] as? String else { continue }
                
                // Buscar URL correspondiente
                if let imageURL = imageURLs[imageName] {
                    group.enter()
                    
                    productsRef.document(document.documentID).updateData([
                        "imageURL": imageURL
                    ]) { error in
                        if let error = error {
                            print("❌ Error actualizando producto \(document.documentID): \(error.localizedDescription)")
                        } else {
                            updateCount += 1
                            print("✅ Producto actualizado con URL: \(imageName)")
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("🎉 \(updateCount) productos actualizados con URLs de Firebase")
                completion(true)
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
