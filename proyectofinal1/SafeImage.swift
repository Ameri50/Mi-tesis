import SwiftUI

// MARK: - Helper para imágenes seguras desde Assets
struct SafeImage: View {
    let imageName: String
    let systemName: String?
    let size: CGFloat
    let backgroundColor: Color
    
    init(imageName: String, systemName: String? = nil, size: CGFloat = 75, backgroundColor: Color) {
        self.imageName = imageName
        self.systemName = systemName
        self.size = size
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            
            // Verificar si la imagen existe en Assets
            if !imageName.isEmpty && UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            } else if let systemName = systemName {
                // Usar systemName como fallback
                Image(systemName: systemName)
                    .font(.system(size: size * 0.6))
                    .foregroundStyle(.orange)
            } else {
                // Placeholder por defecto
                VStack(spacing: 8) {
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.system(size: size * 0.5))
                        .foregroundStyle(.red.opacity(0.6))
                    
                    Text("No image")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
            }
        }
        .frame(width: size, height: size)
        .cornerRadius(10)
    }
}

// MARK: - Preview para Testing
#if DEBUG
struct SafeImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Imagen válida (si existe en Assets)
            SafeImage(
                imageName: "validImage",
                size: 100,
                backgroundColor: Color.gray.opacity(0.2)
            )
            
            // Imagen no existente con fallback de systemName
            SafeImage(
                imageName: "invalidImage",
                systemName: "star.fill",
                size: 100,
                backgroundColor: Color.blue.opacity(0.2)
            )
            
            // Imagen no existente sin fallback
            SafeImage(
                imageName: "missingImage",
                size: 100,
                backgroundColor: Color.orange.opacity(0.2)
            )
        }
        .padding()
    }
}
#endif
