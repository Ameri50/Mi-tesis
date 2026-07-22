import SwiftUI

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
            RemoteOrLocalImage(source: imageName, contentMode: .fit)
                .padding(8)
        }
        .frame(width: size, height: size)
        .cornerRadius(10)
    }
}
