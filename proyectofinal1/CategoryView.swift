import SwiftUI

struct CategoryModel: Identifiable {
    let id = UUID()
    let title: String
    let products: [SeedProduct]
}

struct CategoryView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    @State private var categories: [CategoryModel] = []
    @State private var searchText: String = ""
    @State private var selectedCategoryFilter: String = "Todos"
    @State private var showCart = false
    
    var localizedCategoryNames: [String] {
        [
            localizationManager.translate("category.all"),
            localizationManager.translate("category.ipad"),
            localizationManager.translate("category.iphone"),
            localizationManager.translate("category.mac"),
            localizationManager.translate("category.applewatch"),
            localizationManager.translate("category.accessories")
        ]
    }

    var filteredCategories: [CategoryModel] {
        var filtered = categories
        
        if !searchText.isEmpty {
            filtered = filtered.filter { category in
                category.title.localizedCaseInsensitiveContains(searchText) ||
                category.products.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        if selectedCategoryFilter != localizationManager.translate("category.all") {
            filtered = filtered.filter { getCategoryLocalizedName($0.title) == selectedCategoryFilter }
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
                // MARK: - Toolbar con Carrito
                HStack(spacing: 12) {
                    Text(localizationManager.translate("common.shop"))
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
                        filtersSection
                        
                        if filteredCategories.isEmpty {
                            emptyStateSection
                        } else {
                            categoriesCardsSection
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
                    .environmentObject(userManager)
                    .environmentObject(cartManager)
            }
        }
        .onAppear {
            categories = Self.buildCategories(from: ProductData.products)
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
    
    private var filtersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.translate("home.categories"))
                .font(.system(size: fontSize + 2, weight: .semibold))
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(localizedCategoryNames, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategoryFilter == category,
                            fontSize: fontSize,
                            isDarkMode: themeManager.isDarkMode,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategoryFilter = category
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
    
    private var categoriesCardsSection: some View {
        VStack(spacing: 12) {
            ForEach(filteredCategories) { category in
                NavigationLink(destination: ProductListView(category: category.title)
                    .environmentObject(themeManager)
                    .environmentObject(cartManager)
                    .environmentObject(localizationManager)
                ) {
                    CategoryCardView(category: category)
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                }
            }
        }
        .padding(.bottom, 16)
    }

    private static func buildCategories(from allProducts: [SeedProduct]) -> [CategoryModel] {
        let categoryNames = ["iPad", "iPhone", "Mac", "Apple Watch", "AirPods", "TV y Casa", "Accesorios"]
        
        return categoryNames.compactMap { categoryName in
            let products = allProducts.filter {
                $0.category.lowercased().contains(categoryName.lowercased())
            }
            return products.isEmpty ? nil : CategoryModel(title: categoryName, products: products)
        }
    }
    
    private func getCategoryLocalizedName(_ category: String) -> String {
        switch category {
        case "iPad":
            return localizationManager.translate("category.ipad")
        case "iPhone":
            return localizationManager.translate("category.iphone")
        case "Mac":
            return localizationManager.translate("category.mac")
        case "Apple Watch":
            return localizationManager.translate("category.applewatch")
        case "Accesorios":
            return localizationManager.translate("category.accessories")
        default:
            return category
        }
    }
}

// MARK: - CategoryCardView ARREGLADA
struct CategoryCardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    let category: CategoryModel

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            SafeImage(
                imageName: getCategoryImageName(category.title),
                size: 75,
                backgroundColor: Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : UIColor(white: 0.95, alpha: 1)
                })
            )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(getCategoryLocalizedName(category.title))
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                
                let productCount = category.products.count
                let productText = productCount == 1 ? localizationManager.translate("category.product") : localizationManager.translate("category.products")
                Text("\(productCount) \(productText)")
                    .font(.system(size: fontSize - 4, weight: .regular))
                    .foregroundStyle(themeManager.isDarkMode ? .gray : .black.opacity(0.5))
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
    
    private func getCategoryLocalizedName(_ category: String) -> String {
        switch category {
        case "iPad":
            return localizationManager.translate("category.ipad")
        case "iPhone":
            return localizationManager.translate("category.iphone")
        case "Mac":
            return localizationManager.translate("category.mac")
        case "Apple Watch":
            return localizationManager.translate("category.applewatch")
        case "Accesorios":
            return localizationManager.translate("category.accessories")
        default:
            return category
        }
    }
    
    private func getCategoryImageName(_ category: String) -> String {
        switch category {
        case "iPad":
            return "ipad"
        case "iPhone":
            return "iphone1"
        case "Mac":
            return "macbook"
        case "Apple Watch":
            return "applewatch"
        case "AirPods":
            return "airpods"
        case "TV y Casa":
            return "appletvbox"
        case "Accesorios":
            return "airpods"
        default:
            return "logo"
        }
    }
}

#Preview {
    NavigationStack {
        CategoryView()
            .environmentObject(CartManager())
            .environmentObject(UserManager())
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
