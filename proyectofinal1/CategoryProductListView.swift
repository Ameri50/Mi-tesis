import SwiftUI

struct CategoryProductListView: View {
    let category: ProductCategory
    let selectedFilter: String

    var filteredProducts: [Product] {
        guard selectedFilter != "Todos" else { return category.products }
        return category.products.filter { $0.name.localizedCaseInsensitiveContains(selectedFilter) }
    }

    var body: some View {
        List {
            Section(header: Text(category.title)) {
                ForEach(filteredProducts) { product in
                    HStack {
                        Image(product.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading) {
                            Text(product.name)
                            Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.title)
    }
}

#Preview {
    NavigationStack {
        CategoryProductListView(
            category: ProductCategory(
                title: "iPhone",
                products: [
                    Product(id: UUID(), name: "iPhone 15", price: 799, imageName: "iphone1", category: "iPhone", specs: "", reviews: [], weight: 0.0, dimensions: "", color: "", suggestedDevices: [], additionalImages: nil, description: ""),
                    Product(id: UUID(), name: "iPhone 15 Pro", price: 999, imageName: "iphone2", category: "iPhone", specs: "", reviews: [], weight: 0.0, dimensions: "", color: "", suggestedDevices: [], additionalImages: nil, description: "")
                ]
            ),
            selectedFilter: "Todos"
        )
    }
}
