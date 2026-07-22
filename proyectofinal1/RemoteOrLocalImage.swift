import SwiftUI

/// Muestra una imagen desde una URL remota (http/https) o desde un asset local.
struct RemoteOrLocalImage: View {
    let source: String
    var contentMode: ContentMode = .fill

    private var isRemoteURL: Bool {
        source.lowercased().hasPrefix("http://") || source.lowercased().hasPrefix("https://")
    }

    var body: some View {
        Group {
            if isRemoteURL, let url = URL(string: source) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: contentMode)
                    case .empty:
                        ZStack { Color.gray.opacity(0.1); ProgressView() }
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else if !source.isEmpty, UIImage(named: source) != nil {
                Image(source)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(systemName: "photo.badge.exclamationmark")
                .foregroundStyle(.gray.opacity(0.5))
        }
    }
}
