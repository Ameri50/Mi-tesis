import Foundation

// MARK: - Helpers para Recomendaciones

extension Array where Element == Product {
    
    /// Retorna estadísticas sobre recomendaciones para un producto
    func recommendationStats(for product: Product) -> RecommendationStats {
        let relatedCount = self.related(to: product).count
        let accessoriesCount = self.accessories(for: product).count
        let personalizedAccessories = self.accessories(for: product).filter { !$0.suggestedDevices.isEmpty }
        let genericAccessories = self.accessories(for: product).filter { $0.suggestedDevices.isEmpty }
        
        return RecommendationStats(
            relatedProductsCount: relatedCount,
            totalAccessoriesCount: accessoriesCount,
            personalizedAccessoriesCount: personalizedAccessories.count,
            genericAccessoriesCount: genericAccessories.count,
            personalizationPercentage: accessoriesCount > 0 ?
                Double(personalizedAccessories.count) / Double(accessoriesCount) * 100 : 0
        )
    }
    
    /// Retorna productos similares con opciones de filtrado
    func similarProducts(
        to product: Product,
        byCategory: Bool = true,
        byPrice: Bool = false,
        priceRange: ClosedRange<Double>? = nil,
        limit: Int = 10
    ) -> [Product] {
        var candidates = self.filter { $0.id != product.id }
        
        if byCategory {
            candidates = candidates.filter { $0.category == product.category }
        }
        
        if byPrice, let range = priceRange {
            candidates = candidates.filter { range.contains($0.price) }
        }
        
        // Prioriza en stock
        candidates.sort { $0.inStock && !$1.inStock }
        
        return Array(candidates.prefix(limit))
    }
    
    /// Retorna accesorios que mejor coinciden con el carrito actual
    func recommendAccessoriesForCart(_ cartItems: [Product], limit: Int = 8) -> [Product] {
        let cartCategories = Set(cartItems.map { $0.category })
        let cartIds = Set(cartItems.map { $0.id })
        
        return self.recommendations(
            excluding: cartIds,
            favoringCategories: cartCategories,
            limit: limit
        )
    }
    
    /// Busca accesorios por nombre o descripción
    func searchAccessories(_ query: String) -> [Product] {
        let lowercased = query.lowercased()
        
        return self.filter { product in
            product.category.localizedCaseInsensitiveContains("accesorio") &&
            (product.name.lowercased().contains(lowercased) ||
             product.description.lowercased().contains(lowercased) ||
             product.tags.contains { $0.lowercased().contains(lowercased) })
        }
    }
    
    /// Retorna productos top/trending
    func trendingProducts(limit: Int = 10) -> [Product] {
        self.sorted { p1, p2 in
            // Prioriza: en stock, rating alto, reviews muchas, reciente en venta
            if p1.inStock != p2.inStock {
                return p1.inStock
            }
            if p1.rating != p2.rating {
                return p1.rating > p2.rating
            }
            return p1.reviewCount > p2.reviewCount
        }
        .prefix(limit)
        .map { $0 }
    }
    
    /// Retorna productos en promoción
    func onSaleProducts(limit: Int = 10) -> [Product] {
        self.filter { $0.isOnSale }
            .sorted { $0.discount > $1.discount }
            .prefix(limit)
            .map { $0 }
    }
    
    /// Agrupa accesorios por dispositivo compatible
    func accessoriesGroupedByDevice() -> [String: [Product]] {
        var grouped: [String: [Product]] = [:]
        
        let accessories = self.filter {
            $0.category.localizedCaseInsensitiveContains("accesorio")
        }
        
        for accessory in accessories {
            if accessory.suggestedDevices.isEmpty {
                // Agrupa en "Genéricos"
                if grouped["Genéricos"] == nil {
                    grouped["Genéricos"] = []
                }
                grouped["Genéricos"]?.append(accessory)
            } else {
                // Agrupa por cada dispositivo
                for device in accessory.suggestedDevices {
                    if grouped[device] == nil {
                        grouped[device] = []
                    }
                    grouped[device]?.append(accessory)
                }
            }
        }
        
        return grouped
    }
    
    /// Retorna una recomendación personalizada según historial de compras
    func recommendBasedOnHistory(
        purchaseHistory: [Product],
        excludeIds: Set<String> = Set(),
        limit: Int = 6
    ) -> [Product] {
        guard !purchaseHistory.isEmpty else { return [] }
        
        // Categorías del historial
        let categories = Set(purchaseHistory.map { $0.category })
        
        // Busca productos similares a lo que ha comprado
        var recommendations: [Product] = []
        
        for category in categories {
            let inCategory = self.filter {
                $0.category == category &&
                !excludeIds.contains($0.id) &&
                purchaseHistory.first { $0.id == $0.id } == nil
            }
            recommendations.append(contentsOf: inCategory)
        }
        
        // Agrega accesorios compatibles
        for purchasedProduct in purchaseHistory {
            let compat = self.accessories(for: purchasedProduct).filter {
                !excludeIds.contains($0.id) &&
                !recommendations.contains { $0.id == $0.id }
            }
            recommendations.append(contentsOf: compat)
        }
        
        // Prioriza en stock y rating
        recommendations.sort { p1, p2 in
            if p1.inStock != p2.inStock {
                return p1.inStock
            }
            return p1.rating > p2.rating
        }
        
        return Array(recommendations.prefix(limit))
    }
    
    /// Retorna accesorios "must-have" para un dispositivo
    func essentialAccessories(
        for product: Product,
        limit: Int = 5
    ) -> [Product] {
        let accessories = self.accessories(for: product)
        
        // Prioriza accesorios que: están personalizados + en stock + buena rating
        return accessories
            .sorted { a1, a2 in
                let a1Score = (a1.suggestedDevices.isEmpty ? 0 : 1) +
                              (a1.inStock ? 1 : 0) +
                              Int(a1.rating)
                let a2Score = (a2.suggestedDevices.isEmpty ? 0 : 1) +
                              (a2.inStock ? 1 : 0) +
                              Int(a2.rating)
                return a1Score > a2Score
            }
            .prefix(limit)
            .map { $0 }
    }
}

// MARK: - Model: RecommendationStats

struct RecommendationStats {
    let relatedProductsCount: Int
    let totalAccessoriesCount: Int
    let personalizedAccessoriesCount: Int
    let genericAccessoriesCount: Int
    let personalizationPercentage: Double
    
    var summary: String {
        let percentage = String(format: "%.0f", personalizationPercentage)
        return "\(personalizedAccessoriesCount) accesorios personalizados (\(percentage)%) de \(totalAccessoriesCount) total"
    }
}

// MARK: - Extension: Debugging

extension Product {
    /// Debug: Imprime información de compatibilidad
    func printCompatibilityInfo() {
        print("📱 \(self.name)")
        print("   Categoría: \(self.category)")
        print("   Compatible con: \(self.compatibleWith.isEmpty ? "ninguno" : self.compatibleWith.joined(separator: ", "))")
        print("   Suggested Devices: \(self.suggestedDevices.isEmpty ? "ninguno" : self.suggestedDevices.joined(separator: ", "))")
        print("   Tags: \(self.tags.isEmpty ? "ninguno" : self.tags.joined(separator: ", "))")
    }
}

extension Array where Element == Product {
    /// Debug: Imprime estadísticas de recomendaciones
    func printRecommendationStats() {
        print("\n🔍 Estadísticas de Recomendaciones\n")
        
        let accessories = self.filter { $0.category.localizedCaseInsensitiveContains("accesorio") }
        let personalized = accessories.filter { !$0.suggestedDevices.isEmpty }
        let generic = accessories.filter { $0.suggestedDevices.isEmpty }
        
        print("Total de accesorios: \(accessories.count)")
        print("  - Personalizados: \(personalized.count)")
        print("  - Genéricos: \(generic.count)")
        
        let grouped = self.accessoriesGroupedByDevice()
        print("\nAcoplados por dispositivo:")
        for (device, accs) in grouped.sorted(by: { $0.key < $1.key }) {
            print("  \(device): \(accs.count) accesorios")
        }
    }
    
    /// Debug: Verifica que los datos están bien configurados
    func validateRecommendationData() -> [String] {
        var warnings: [String] = []
        
        for product in self {
            // Alerta si un accesorio no tiene suggestedDevices
            if product.category.localizedCaseInsensitiveContains("accesorio") &&
               product.suggestedDevices.isEmpty &&
               product.compatibleWith.isEmpty {
                warnings.append("⚠️  '\(product.name)' es accesorio pero no tiene suggestedDevices ni compatibleWith")
            }
            
            // Alerta si suggestedDevices no coincide con compatibleWith
            if !product.suggestedDevices.isEmpty && product.compatibleWith.isEmpty {
                warnings.append("⚠️  '\(product.name)' tiene suggestedDevices pero no compatibleWith")
            }
        }
        
        if warnings.isEmpty {
            print("✅ Todos los productos están correctamente configurados")
        } else {
            print("⚠️  Se encontraron \(warnings.count) problemas:")
            for warning in warnings {
                print(warning)
            }
        }
        
        return warnings
    }
}
