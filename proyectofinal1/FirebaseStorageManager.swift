import Foundation
import FirebaseStorage
import SwiftUI

class FirebaseStorageManager: NSObject, ObservableObject {
    static let shared = FirebaseStorageManager()
    
    @Published var uploadProgress: Double = 0
    @Published var isUploading = false
    @Published var errorMessage: String?
    
    private let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
    
    override init() {
        super.init()
        print("✅ FirebaseStorageManager inicializado")
    }
    
    // MARK: - Subir Imagen
    func uploadImage(
        _ image: UIImage,
        fileName: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        isUploading = true
        errorMessage = nil
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Error al procesar imagen"
            isUploading = false
            completion(.failure(NSError(domain: "ImageError", code: -1)))
            return
        }
        
        let imageRef = storageRef.child("products/\(fileName).jpg")
        
        print("📤 Subiendo imagen: \(fileName)")
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = "Error subiendo imagen: \(error.localizedDescription)"
                self.isUploading = false
                print("❌ Error: \(self.errorMessage ?? "")")
                completion(.failure(error))
                return
            }
            
            // Obtener URL de descarga
            imageRef.downloadURL { url, error in
                if let url = url {
                    print("✅ Imagen subida: \(url.absoluteString)")
                    self.isUploading = false
                    completion(.success(url.absoluteString))
                } else if let error = error {
                    self.errorMessage = "Error obteniendo URL: \(error.localizedDescription)"
                    self.isUploading = false
                    print("❌ Error: \(self.errorMessage ?? "")")
                    completion(.failure(error))
                }
            }
        }
        
        // Monitorear progreso
        uploadTask.observe(.progress) { [weak self] snapshot in
            guard let self = self else { return }
            let progress = Double(snapshot.progress?.fractionCompleted ?? 0)
            DispatchQueue.main.async {
                self.uploadProgress = progress
            }
            print("📊 Progreso: \(Int(progress * 100))%")
        }
    }
    
    // MARK: - Descargar Imagen
    func downloadImage(
        fileName: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        let imageRef = storageRef.child("products/\(fileName).jpg")
        
        print("📥 Descargando imagen: \(fileName)")
        
        // Descargar máximo 5MB
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("❌ Error descargando imagen: \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                print("✅ Imagen descargada: \(fileName)")
                completion(.success(image))
            } else {
                let error = NSError(domain: "ImageError", code: -1)
                print("❌ Error procesando imagen")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Obtener URL de Imagen
    func getImageURL(
        fileName: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let imageRef = storageRef.child("products/\(fileName).jpg")
        
        imageRef.downloadURL { url, error in
            if let url = url {
                print("✅ URL de imagen obtenida: \(url.absoluteString)")
                completion(.success(url))
            } else if let error = error {
                print("❌ Error obteniendo URL: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Eliminar Imagen
    func deleteImage(
        fileName: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let imageRef = storageRef.child("products/\(fileName).jpg")
        
        imageRef.delete { error in
            if let error = error {
                print("❌ Error eliminando imagen: \(error)")
                completion(.failure(error))
            } else {
                print("✅ Imagen eliminada: \(fileName)")
                completion(.success(()))
            }
        }
    }
}
