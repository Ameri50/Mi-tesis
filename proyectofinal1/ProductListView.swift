import SwiftUI

struct ProductListView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var cartManager: CartManager
    
    let category: String
    @State private var searchText: String = ""

    var filteredProducts: [SeedProduct] {
        if searchText.isEmpty {
            return ProductData.products.filter { $0.category == category }
        } else {
            return ProductData.products.filter {
                $0.category == category &&
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ZStack {
            // ✅ Fondo dinámico según el tema
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            })
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredProducts) { product in
                        NavigationLink(destination: ProductDetailView(product: product)
                            .environmentObject(themeManager)
                            .environmentObject(cartManager)
                        ) {
                            ProductRowView(product: product)
                                .environmentObject(themeManager)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Buscar productos...")
    }
}

struct ProductRowView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    
    let product: SeedProduct
    
    var body: some View {
        HStack(spacing: 16) {
            // Para imágenes locales
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor { _ in
                            themeManager.isDarkMode ? UIColor(white: 0.20, alpha: 1) : .systemGray5
                        }))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: fontSize + 2, weight: .semibold))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .primary)
                    .multilineTextAlignment(.leading)

                Text(String(format: "$%.2f", product.price))
                    .font(.system(size: fontSize - 1, weight: .regular))
                    .foregroundStyle(themeManager.isDarkMode ? .gray : .secondary)
                    .adaptiveOneLine()
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray6
                }))
                .shadow(color: .black.opacity(themeManager.isDarkMode ? 0.2 : 0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// Versión para compatibilidad con iOS 14 y anteriores
struct ProductListViewLegacy: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var cartManager: CartManager
    
    let category: String
    @State private var searchText: String = ""

    var filteredProducts: [SeedProduct] {
        if searchText.isEmpty {
            return ProductData.products.filter { $0.category == category }
        } else {
            return ProductData.products.filter {
                $0.category == category &&
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            })
            .ignoresSafeArea()
            
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)
                                .environmentObject(themeManager)
                                .environmentObject(cartManager)
                            ) {
                                ProductRowViewLegacy(product: product)
                                    .environmentObject(themeManager)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProductRowViewLegacy: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    
    let product: SeedProduct
    
    var body: some View {
        HStack(spacing: 16) {
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor { _ in
                            themeManager.isDarkMode ? UIColor(white: 0.20, alpha: 1) : .systemGray5
                        }))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: fontSize + 2, weight: .semibold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    .multilineTextAlignment(.leading)

                Text(String(format: "$%.2f", product.price))
                    .font(.system(size: fontSize - 1, weight: .regular))
                    .foregroundColor(themeManager.isDarkMode ? .gray : .secondary)
                    .adaptiveOneLine()
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray6
                }))
                .shadow(color: .black.opacity(themeManager.isDarkMode ? 0.2 : 0.05), radius: 2, x: 0, y: 1)
        )
    }
}

#Preview("Modo Claro") {
    NavigationView {
        ProductListView(category: "iPhone")
            .environmentObject(CartManager())
            .environmentObject(ThemeManager())
    }
    .preferredColorScheme(.light)
}

#Preview("Modo Oscuro") {
    NavigationView {
        ProductListView(category: "iPhone")
            .environmentObject(CartManager())
            .environmentObject(ThemeManager())
    }
    .preferredColorScheme(.dark)
}

// MARK: - Legacy SearchBar for iOS 13/14
struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Buscar productos..."
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
}
