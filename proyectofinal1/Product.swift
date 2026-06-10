import Foundation

// MARK: - Product Model (Actualizado para Firebase)
struct Product: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Double
    let imageName: String           // ✅ Mantener para compatibilidad local
    let imageURL: String?           // 🆕 URL de Firebase Storage
    let category: String
    let specs: String
    let reviews: [String]
    let weight: Double
    let dimensions: String
    let color: String
    let suggestedDevices: [String]
    let additionalImages: [String]?
    let description: String
    
    // MARK: - Computed Property
    /// Retorna la URL final de la imagen (Firebase o local)
    var finalImageURL: String {
        return imageURL ?? imageName
    }
    
    // MARK: - Inicializador con valores por defecto
    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        imageName: String,
        imageURL: String? = nil,
        category: String,
        specs: String = "",
        reviews: [String] = [],
        weight: Double = 0.0,
        dimensions: String = "",
        color: String = "",
        suggestedDevices: [String] = [],
        additionalImages: [String]? = nil,
        description: String = ""
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.imageName = imageName
        self.imageURL = imageURL
        self.category = category
        self.specs = specs
        self.reviews = reviews
        self.weight = weight
        self.dimensions = dimensions
        self.color = color
        self.suggestedDevices = suggestedDevices
        self.additionalImages = additionalImages
        self.description = description
    }
}

// NOTA: SeedProduct ya existe en ProductData.swift
// No es necesario duplicarlo aquí
