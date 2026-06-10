import SwiftUI
import FirebaseStorage

// MARK: - FirebaseAsyncImage
/// Componente que carga imágenes desde Firebase Storage con caché
struct FirebaseAsyncImage: View {
    let imageName: String
    let imageURL: String?
    let placeholder: String
    let contentMode: ContentMode
    
    @State private var loadedImage: UIImage?
    @State private var isLoading = true
    
    init(
        imageName: String,
        imageURL: String? = nil,
        placeholder: String = "photo",
        contentMode: ContentMode = .fit
    ) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.placeholder = placeholder
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                // ✅ Imagen cargada desde Firebase
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                // 🔄 Cargando desde Firebase
                ZStack {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .opacity(0.3)
                    
                    ProgressView()
                        .scaleEffect(0.8)
                }
            } else {
                // ❌ Error: usar imagen local
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            }
        }
        .onAppear {
            loadImageFromFirebase()
        }
    }
    
    // MARK: - Load Image
    private func loadImageFromFirebase() {
        // Si no hay URL de Firebase, usar imagen local
        guard let firebaseURL = imageURL, !firebaseURL.isEmpty else {
            isLoading = false
            return
        }
        
        // Verificar caché primero
        if let cachedImage = ImageCache.shared.get(forKey: firebaseURL) {
            self.loadedImage = cachedImage
            self.isLoading = false
            return
        }
        
        // Cargar desde Firebase Storage
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("products/\(imageName).png")
        
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ Error cargando imagen \(imageName): \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    self.loadedImage = image
                    ImageCache.shared.set(image, forKey: firebaseURL)
                    print("✅ Imagen \(imageName) cargada desde Firebase")
                }
            }
        }
    }
}

// MARK: - Image Cache
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100 // Máximo 100 imágenes en caché
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}

// MARK: - Preview
#Preview {
    VStack {
        FirebaseAsyncImage(
            imageName: "ipad",
            imageURL: nil,
            placeholder: "ipad"
        )
        .frame(width: 100, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
