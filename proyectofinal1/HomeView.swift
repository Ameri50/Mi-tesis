import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var fontSizeManager: AppFontSizeManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    
    @State private var selectedCategory: String = "Todos"
    @State private var searchText: String = ""
    @State private var showCart = false
    
    @ObservedObject private var store = ProductStore.shared
    var products: [SeedProduct] { store.products }
    let categories = ["Todos", "iPad", "iPhone", "Mac", "Apple Watch", "AirPods", "TV y Casa"]
    
    var filteredProducts: [SeedProduct] {
        var filtered = products
        
        if selectedCategory != "Todos" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            })
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text(localizationManager.translate("home.store"))
                        .font(.system(size: fontSize + 1, weight: .semibold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    
                    Spacer()
                    
                    Button(action: { showCart = true }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            
                            if cartManager.totalItemsCount > 0 {
                                Text("\(cartManager.totalItemsCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 18, minHeight: 18)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
                }))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        searchBarSection
                        RepairServiceBanner()
                            .environmentObject(themeManager)
                            .environmentObject(localizationManager)
                        categoriesSection
                        
                        if filteredProducts.isEmpty {
                            emptyStateSection
                        } else {
                            productsSection
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                }
            }
            .navigationDestination(isPresented: $showCart) {
                CartView()
                    .environmentObject(themeManager)
                    .environmentObject(localizationManager)
                    .environmentObject(cartManager)
            }
        }
    }
    
    private var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(
                localizationManager.translate("home.searchPlaceholder"),
                text: $searchText
            )
            .font(.system(size: fontSize))
            .foregroundColor(themeManager.isDarkMode ? .white : .black)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .secondarySystemBackground
        }))
        .cornerRadius(10)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.translate("home.categories"))
                .font(.system(size: fontSize + 2, weight: .semibold))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category,
                            fontSize: fontSize,
                            isDarkMode: themeManager.isDarkMode,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = category
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "cube.box")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.3))
            
            Text(localizationManager.translate("home.noCategoryProducts"))
                .font(.system(size: fontSize - 2, weight: .medium))
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 60)
    }
    
    private var productsSection: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(product: product)
                    .environmentObject(themeManager)
                    .environmentObject(cartManager)
                ) {
                    HomeProductCardView(product: product)
                        .environmentObject(themeManager)
                }
            }
        }
        .padding(.bottom, 16)
    }
}

// MARK: - HomeProductCardView ARREGLADA
struct HomeProductCardView: View {
    let product: SeedProduct
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            SafeImage(
                imageName: product.imageName,
                size: 75,
                backgroundColor: Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : UIColor(white: 0.95, alpha: 1)
                })
            )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    .lineLimit(2)
                
                Text(String(format: "$%.2f", product.price))
                    .font(.system(size: fontSize - 2, weight: .regular))
                    .foregroundStyle(themeManager.isDarkMode ? .gray : .black.opacity(0.6))
                
                Text(product.category)
                    .font(.system(size: fontSize - 4, weight: .regular))
                    .foregroundStyle(.gray.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.gray.opacity(0.4))
        }
        .padding(14)
        .frame(minHeight: 95)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
        }))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(themeManager.isDarkMode ? 0.2 : 0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(CartManager())
        .environmentObject(AppFontSizeManager.shared)
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
