import SwiftUI
import FirebaseFirestore

@MainActor
class StoreViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        loadProducts()
    }
    
    // MARK: - Cargar productos en tiempo real
    func loadProducts() {
        isLoading = true
        errorMessage = nil
        
        // Escuchar cambios en tiempo real desde Firestore
        listener = db.collection("products")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Error al cargar productos: \(error.localizedDescription)"
                        print("❌ Error Firestore: \(error)")
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        self.errorMessage = "Sin datos"
                        return
                    }
                    
                    self.products = snapshot.documents.compactMap { doc in
                        do {
                            var product = try doc.data(as: Product.self)
                            product.id = doc.documentID
                            return product
                        } catch {
                            print("❌ Error decodificando producto: \(error)")
                            return nil
                        }
                    }
                    
                    print("✅ Cargados \(self.products.count) productos de Firestore")
                }
            }
    }
    
    // MARK: - Obtener producto por ID
    func getProduct(by id: String) -> Product? {
        products.first { $0.id == id }
    }
    
    // MARK: - Filtrar por categoría
    func getProducts(for category: String) -> [Product] {
        products.filter { $0.category == category }
    }
    
    // MARK: - Búsqueda
    func searchProducts(query: String) -> [Product] {
        guard !query.isEmpty else { return products }
        return products.filter { product in
            product.name.lowercased().contains(query.lowercased()) ||
            product.description.lowercased().contains(query.lowercased())
        }
    }
    
    // MARK: - Categorías únicas
    var categories: [String] {
        Array(Set(products.map { $0.category })).sorted()
    }
    
    // MARK: - Limpiar listener
    deinit {
        listener?.remove()
    }
}
