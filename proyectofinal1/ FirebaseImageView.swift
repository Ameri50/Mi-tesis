import SwiftUI

// MARK: - Firebase Image View con caché
struct FirebaseImageView: View {
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var error: String?
    
    let fileName: String
    let placeholder: String
    
    var body: some View {
        ZStack {
            // Color de fondo
            Color.gray.opacity(0.1)
            
            // Mientras carga
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            // Imagen cargada
            else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            // Imagen de respaldo (Assets)
            else {
                Image(placeholder)
                    .resizable()
                    .scaledToFill()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        error = nil
        
        let storageManager = FirebaseStorageManager.shared
        storageManager.downloadImage(fileName: fileName) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let downloadedImage):
                    self.image = downloadedImage
                    print("✅ Imagen cargada: \(fileName)")
                case .failure(let err):
                    self.error = err.localizedDescription
                    print("❌ Error cargando imagen: \(fileName) - \(err.localizedDescription)")
                    // Cargar desde Assets como respaldo
                    self.image = UIImage(named: fileName)
                }
            }
        }
    }
}

// MARK: - Alternativa con URL directo
struct URLImageView: View {
    @State private var image: UIImage?
    @State private var isLoading = false
    
    let urlString: String
    let placeholder: String
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(placeholder)
                    .resizable()
                    .scaledToFill()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            defer {
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
            
            guard let data = data, error == nil else {
                print("❌ Error descargando imagen: \(error?.localizedDescription ?? "desconocido")")
                return
            }
            
            if let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    print("✅ Imagen descargada desde URL")
                }
            }
        }.resume()
    }
}

// MARK: - Preview
#Preview {
    FirebaseImageView(fileName: "ipad", placeholder: "ipad")
        .frame(height: 200)
}
