import Foundation

// MARK: - Generación Apple por año
enum AppleGeneracion: String, CaseIterable {
    case gen2021   = "Ecosistema 2021 (M1 Pro)"
    case gen2022   = "Ecosistema 2022 (M2)"
    case gen2023   = "Ecosistema 2023 (USB-C)"
    case gen2024   = "Ecosistema 2024 (IA)"
    case genActual = "Ecosistema Actual 2025-2026"
}

// MARK: - Paleta de colores Apple (referencia interna, NO expuesta globalmente)
// Cada producto toma solo los colores que le corresponden
private enum C {
    // Neutros / metálicos
    static let plata            = ColorOption(name: "Plata",                hexColor: "#E8E8ED")
    static let grisEspacial     = ColorOption(name: "Gris Espacial",        hexColor: "#3A3A3C")
    static let negroEspacial    = ColorOption(name: "Negro Espacial",       hexColor: "#1C1C1E")
    static let negro            = ColorOption(name: "Negro",                hexColor: "#1C1C1E")
    static let blanco           = ColorOption(name: "Blanco",               hexColor: "#F5F5F0")
    static let luzEstelar       = ColorOption(name: "Luz Estelar",          hexColor: "#F0EDE4")
    static let medianoche       = ColorOption(name: "Medianoche",           hexColor: "#222930")
    // Titanio (Pro)
    static let titNegro         = ColorOption(name: "Titanio Negro",        hexColor: "#2C2C2E")
    static let titBlanco        = ColorOption(name: "Titanio Blanco/Plata", hexColor: "#E8E8ED")
    static let titNatural       = ColorOption(name: "Titanio Natural",      hexColor: "#C8B89A")
    static let titDesierto      = ColorOption(name: "Titanio Desierto",     hexColor: "#C6A882")
    static let titTeal          = ColorOption(name: "Titanio Teal",         hexColor: "#3E7A7E")
    static let titAzul          = ColorOption(name: "Titanio Azul",         hexColor: "#4A6FA5")
    static let titanio          = ColorOption(name: "Titanio",              hexColor: "#8E8E93")
    // Colores vivos iPhone / Watch / iPad
    static let rosa             = ColorOption(name: "Rosa",                 hexColor: "#F2A7BB")
    static let rosaClaro        = ColorOption(name: "Rosa Claro",           hexColor: "#F4C2C2")
    static let oroRosa          = ColorOption(name: "Oro Rosa",             hexColor: "#E8B4B8")
    static let rojo             = ColorOption(name: "Rojo",                 hexColor: "#FF3B30")
    static let productoRED      = ColorOption(name: "Product RED",          hexColor: "#BF0000")
    static let azul             = ColorOption(name: "Azul",                 hexColor: "#3478F6")
    static let azulCielo        = ColorOption(name: "Azul Cielo",           hexColor: "#7EC8E3")
    static let azulMedianoche   = ColorOption(name: "Azul Medianoche",      hexColor: "#2C3E6B")
    static let teal             = ColorOption(name: "Teal",                 hexColor: "#3E7A7E")
    static let ultramarino      = ColorOption(name: "Ultramarino",          hexColor: "#3B4A8C")
    static let verde            = ColorOption(name: "Verde",                hexColor: "#30D158")
    static let verdeAlpino      = ColorOption(name: "Verde Alpino",         hexColor: "#4CAF7D")
    static let cian             = ColorOption(name: "Cian",                 hexColor: "#5AC8FA")
    static let amarillo         = ColorOption(name: "Amarillo",             hexColor: "#FFD60A")
    static let naranja          = ColorOption(name: "Naranja",              hexColor: "#FF9F0A")
    static let morado           = ColorOption(name: "Morado",               hexColor: "#BF5AF2")
    static let moradoOscuro     = ColorOption(name: "Morado Oscuro",        hexColor: "#7B3FA0")
    static let oro              = ColorOption(name: "Oro",                  hexColor: "#D4AF37")
    static let grafito          = ColorOption(name: "Grafito",              hexColor: "#5A5A5E")
    // iMac exclusivos
    static let azuliMac         = ColorOption(name: "Azul",                 hexColor: "#6AADCF")
    static let verdeiMac        = ColorOption(name: "Verde",                hexColor: "#75C08B")
    static let rosaiMac         = ColorOption(name: "Rosa",                 hexColor: "#E8A0A8")
    static let amarilloiMac     = ColorOption(name: "Amarillo",             hexColor: "#F3D46A")
    static let naranjaiMac      = ColorOption(name: "Naranja",              hexColor: "#F0956A")
    static let moradoiMac       = ColorOption(name: "Morado",               hexColor: "#9E7FC2")
    // AirPods Max Lightning colores
    static let verdeAM          = ColorOption(name: "Verde",                hexColor: "#4CAF7D")
    static let celesteAM        = ColorOption(name: "Celeste",              hexColor: "#AED6F1")
    static let rosaAM           = ColorOption(name: "Rosa",                 hexColor: "#F8BBD9")
}

// MARK: - Paleta de almacenamientos Apple
private enum S {
    static let g32   = StorageOption(capacity: "32GB",   priceMultiplier: 1.00)
    static let g64   = StorageOption(capacity: "64GB",   priceMultiplier: 1.00)
    static let g128  = StorageOption(capacity: "128GB",  priceMultiplier: 1.00)
    static let g256  = StorageOption(capacity: "256GB",  priceMultiplier: 1.15)
    static let g512  = StorageOption(capacity: "512GB",  priceMultiplier: 1.35)
    static let t1    = StorageOption(capacity: "1TB",    priceMultiplier: 1.60)
    static let t2    = StorageOption(capacity: "2TB",    priceMultiplier: 1.95)
    static let t4    = StorageOption(capacity: "4TB",    priceMultiplier: 2.50)
    static let t8    = StorageOption(capacity: "8TB",    priceMultiplier: 3.20)
}

// MARK: - Builder interno (NO reemplaza la arquitectura por producto)
private func product(
    name: String,
    price: Double,
    category: String,
    imageName: String,
    additionalImages: [String],
    description: String,
    colors: [ColorOption],
    storages: [StorageOption],
    stock: Int = 50,
    rating: Double = 4.5,
    reviewCount: Int = 0,
    isOnSale: Bool = false,
    discount: Int = 0,
    inStock: Bool = true
) -> SeedProduct {
    SeedProduct(
        name: name,
        price: price,
        category: category,
        imageName: imageName,
        additionalImages: additionalImages,
        productDescription: description,
        colorOptions: colors,
        storageOptions: storages,
        stock: stock,
        rating: rating,
        reviewCount: reviewCount,
        isOnSale: isOnSale,
        discount: discount,
        inStock: inStock
    )
}

// MARK: - ProductData
enum ProductData {

    static let seedProducts: [SeedProduct] =
        iPhones + iPads + macs + watches + airpods + tvCasa + accesorios

    // =========================================================================
    // MARK: - iPhone
    // Regla de colores:
    //   Pro / Pro Max → solo colores Titanio (4 colores)
    //   Estándar / Plus / Air / e → colores aluminio (nunca Titanio)
    //   SE → 3 colores fijos
    // Regla de storage:
    //   Pro Max 16/17 → mínimo 256GB
    //   SE3 → 64/128/256 (no 512 ni 1TB)
    //   iPhone 12 → 64/128/256 (no 1TB)
    //
    // AUDITORÍA DE PRECIOS (jun 2026): se corrigieron inversiones donde un
    // modelo anterior costaba más que su sucesor directo. Ver tabla de cambios
    // entregada junto con este archivo.
    // =========================================================================
    private static let iPhones: [SeedProduct] = [

        // ── 2026 ──────────────────────────────────────────────────────────────
        // iPhone 17e — Negro, Blanco, Rosa · 128/256GB
        product(name: "iPhone 17e", price: 2199,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone3","iphone1","iphone2","iphone3"],
            description: "El iPhone más accesible de la familia 17. Pantalla OLED de 6.1\", chip A19 con módem C1X integrado, cámara 48 MP Fusion con 4K Dolby Vision y soporte MagSafe.",
            colors: [C.negro, C.blanco, C.rosa],
            storages: [S.g128, S.g256]),

        // iPhone 17 Pro Max — 4 Titanio · 256/512/1TB
        product(name: "iPhone 17 Pro Max", price: 4999,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "El iPhone más potente. Pantalla Super Retina XDR de 6.9\" ProMotion 120 Hz, chip A19 Pro, triple cámara 48 MP con zoom óptico 5×, chasis de titanio aeroespacial.",
            colors: [C.titNegro, C.titBlanco, C.titNatural, C.titDesierto],
            storages: [S.g256, S.g512, S.t1]),

        // iPhone 17 Pro — 4 Titanio (Teal en lugar de Desierto) · 128/256/512/1TB
        product(name: "iPhone 17 Pro", price: 4499,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone1"],
            description: "Pantalla Super Retina XDR de 6.3\" ProMotion 120 Hz, chip A19 Pro, triple cámara 48 MP con zoom óptico 5×, chasis de titanio aeroespacial cepillado.",
            colors: [C.titNegro, C.titBlanco, C.titNatural, C.titTeal],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // iPhone Air — aluminio ultraligero, NO titanio · 256/512GB
        // Precio corregido: 3899 → 4199 (debe superar al 16 Plus, su predecesor conceptual)
        product(name: "iPhone Air", price: 4199,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone1"],
            description: "El iPhone más delgado de la historia (5.6 mm). Pantalla OLED de 6.6\", chip A19, cámara 48 MP Fusion. Chasis de aluminio aeroespacial ultraligero.",
            colors: [C.azulCielo, C.blanco, C.negro, C.rosa],
            storages: [S.g256, S.g512]),

        // iPhone 17 — 5 colores aluminio · 128/256/512GB
        product(name: "iPhone 17", price: 3199,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "Pantalla OLED de 6.3\" ProMotion 120 Hz con Always-On Display, chip A19, cámara dual 48 MP. El mejor valor de la gama actual.",
            colors: [C.negro, C.blanco, C.ultramarino, C.rosa, C.verde],
            storages: [S.g128, S.g256, S.g512]),

        // ── 2024 ──────────────────────────────────────────────────────────────
        // iPhone 16 Pro Max — 4 Titanio · mínimo 256GB
        // Precio corregido: 5355 → 4700 (no podía superar al sucesor 17 Pro Max)
        product(name: "iPhone 16 Pro Max", price: 4700,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "Pantalla Super Retina XDR de 6.9\" ProMotion 120 Hz, chip A18 Pro, triple cámara 48 MP con zoom óptico 5×. Camera Control físico. Titanio grado 5.",
            colors: [C.titNegro, C.titBlanco, C.titNatural, C.titDesierto],
            storages: [S.g256, S.g512, S.t1]),

        // iPhone 16 Pro — 4 Titanio · 128/256/512/1TB
        product(name: "iPhone 16 Pro", price: 4199,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone1"],
            description: "Pantalla Super Retina XDR de 6.3\" ProMotion 120 Hz, chip A18 Pro, triple cámara 48 MP. Camera Control físico. Titanio grado 5.",
            colors: [C.titNegro, C.titBlanco, C.titNatural, C.titDesierto],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // iPhone 16 Plus — aluminio · 128/256/512GB
        product(name: "iPhone 16 Plus", price: 3899,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone2"],
            description: "Pantalla OLED de 6.7\" con chip A18 y Camera Control. Dynamic Island. Batería de larga duración.",
            colors: [C.negro, C.blanco, C.rosa, C.teal, C.ultramarino],
            storages: [S.g128, S.g256, S.g512]),

        // iPhone 16 — aluminio · 128/256/512GB
        product(name: "iPhone 16", price: 2900,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone3","iphone2","iphone1","iphone3"],
            description: "Pantalla OLED de 6.1\", chip A18 y Camera Control. Dynamic Island. Compatible con Apple Intelligence.",
            colors: [C.negro, C.blanco, C.rosa, C.teal, C.ultramarino],
            storages: [S.g128, S.g256, S.g512]),

        // ── 2025 entrada ──────────────────────────────────────────────────────
        // iPhone 16e — Negro, Blanco · 128/256/512GB
        product(name: "iPhone 16e", price: 2119,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone3","iphone1","iphone2","iphone3"],
            description: "Opción de entrada con chip A18 y Apple Intelligence. Pantalla OLED de 6.1\", cámara 48 MP Fusion, Dynamic Island. Módem C1 integrado.",
            colors: [C.negro, C.blanco],
            storages: [S.g128, S.g256, S.g512]),

        // ── 2023 ──────────────────────────────────────────────────────────────
        // iPhone 15 Pro Max — titanio · mínimo 256GB
        product(name: "iPhone 15 Pro Max", price: 4283,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone1"],
            description: "Pantalla Super Retina XDR de 6.7\" ProMotion, titanio grado 5, cámara 48 MP con zoom tetraprismático 5×. Primer iPhone con puerto USB-C.",
            colors: [C.titNegro, C.titBlanco, C.titAzul, C.titNatural],
            storages: [S.g256, S.g512, S.t1]),

        // iPhone 15 Pro — titanio · 128/256/512/1TB
        product(name: "iPhone 15 Pro", price: 3400,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone2"],
            description: "Pantalla Super Retina XDR de 6.1\" ProMotion, titanio grado 5, cámara 48 MP. USB-C con velocidades USB 3.",
            colors: [C.titNegro, C.titBlanco, C.titAzul, C.titNatural],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // iPhone 15 Plus — aluminio · 128/256/512GB
        product(name: "iPhone 15 Plus", price: 3200,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone3"],
            description: "Pantalla OLED de 6.7\" con Dynamic Island y USB-C. Chip A16 Bionic.",
            colors: [C.negro, C.amarillo, C.verde, C.azul, C.rosa],
            storages: [S.g128, S.g256, S.g512]),

        // iPhone 15 — aluminio · 128/256/512GB
        product(name: "iPhone 15", price: 2600,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone3"],
            description: "Pantalla Super Retina XDR OLED de 6.1\", Dynamic Island, cámara 48 MP y USB-C. Chip A16 Bionic.",
            colors: [C.negro, C.amarillo, C.verde, C.azul, C.rosa],
            storages: [S.g128, S.g256, S.g512]),

        // ── 2022 ──────────────────────────────────────────────────────────────
        // iPhone 14 Pro Max — acero inoxidable · 128/256/512/1TB
        // Precio corregido: 3100 → 3300 (debe superar al 13 Pro Max corregido y quedar < 15 Pro Max)
        product(name: "iPhone 14 Pro Max", price: 3300,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone1"],
            description: "Pantalla Super Retina XDR de 6.7\" ProMotion con Dynamic Island (primer año), cámara 48 MP. Chip A16 Bionic. Always-On Display.",
            colors: [C.negroEspacial, C.plata, C.oro, C.moradoOscuro],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // Precio corregido: 2300 sin cambio, ya queda > 13 Pro corregido (2100) y < 15 Pro (3400)
        product(name: "iPhone 14 Pro", price: 2300,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "Pantalla Super Retina XDR de 6.1\" ProMotion con Dynamic Island, cámara 48 MP. Chip A16 Bionic.",
            colors: [C.negroEspacial, C.plata, C.oro, C.moradoOscuro],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        product(name: "iPhone 14 Plus", price: 2500,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone1"],
            description: "Pantalla OLED de 6.7\", chip A15 Bionic y batería de larga duración. Crash Detection y Emergency SOS vía satélite.",
            colors: [C.medianoche, C.luzEstelar, C.azul, C.morado, C.amarillo, C.productoRED],
            storages: [S.g128, S.g256, S.g512]),

        // Precio corregido: 2200 sin cambio, ya queda > 13 corregido (1750) y < 15 (2600)
        product(name: "iPhone 14", price: 2200,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone3"],
            description: "Pantalla OLED de 6.1\", chip A15 Bionic. Crash Detection y Emergency SOS vía satélite.",
            colors: [C.medianoche, C.luzEstelar, C.azul, C.morado, C.amarillo, C.productoRED],
            storages: [S.g128, S.g256, S.g512]),

        // ── 2021 ──────────────────────────────────────────────────────────────
        // Precio corregido: 2400 → 2900 (debe superar al 12 Pro Max corregido y quedar < 14 Pro Max)
        product(name: "iPhone 13 Pro Max", price: 2900,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone1"],
            description: "Pantalla Super Retina XDR de 6.7\" ProMotion 120 Hz, triple cámara con macro y LiDAR. Chip A15 Bionic.",
            colors: [C.grafito, C.oro, C.plata, C.azul, C.verdeAlpino],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // Precio corregido: 1800 → 2100 (debe superar al 12 Pro corregido y quedar < 14 Pro)
        product(name: "iPhone 13 Pro", price: 2100,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone2"],
            description: "Pantalla Super Retina XDR de 6.1\" ProMotion 120 Hz, triple cámara con macro y LiDAR. Chip A15 Bionic.",
            colors: [C.grafito, C.oro, C.plata, C.azul, C.verdeAlpino],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // Precio corregido: 1499 → 1750 (debe superar al 12 corregido y quedar < 14)
        product(name: "iPhone 13", price: 1750,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone3"],
            description: "Pantalla OLED de 6.1\", chip A15 Bionic, cámara dual avanzada. Muesca más pequeña.",
            colors: [C.medianoche, C.luzEstelar, C.azul, C.rosa, C.verde, C.productoRED],
            storages: [S.g128, S.g256, S.g512]),

        product(name: "iPhone 13 Mini", price: 1300,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone3"],
            description: "Pantalla OLED compacta de 5.4\", chip A15 Bionic. El iPhone más pequeño de su generación.",
            colors: [C.medianoche, C.luzEstelar, C.azul, C.rosa, C.verde, C.productoRED],
            storages: [S.g128, S.g256, S.g512]),

        // iPhone SE 3ª Gen — solo 3 colores, máximo 256GB
        product(name: "iPhone SE (3ª Gen)", price: 1400,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "Pantalla Retina HD de 4.7\", chip A15 Bionic, 5G y Touch ID. La opción más económica con botón de inicio.",
            colors: [C.medianoche, C.luzEstelar, C.productoRED],
            storages: [S.g64, S.g128, S.g256]),

        // ── Históricos ────────────────────────────────────────────────────────
        // Precio corregido: 3211 → 2675 (no podía superar a generaciones posteriores)
        product(name: "iPhone 12 Pro Max", price: 2675,
            category: "iPhone", imageName: "iphone3",
            additionalImages: ["iphone1","iphone2","iphone3","iphone1"],
            description: "Pantalla Super Retina XDR de 6.7\", LiDAR Scanner, cámara triple con zoom óptico 2.5×. Chip A14 Bionic. 5G.",
            colors: [C.grafito, C.plata, C.oro, C.azul],
            storages: [S.g128, S.g256, S.g512]),

        // Precio corregido: 2675 → 1900 (no podía superar a generaciones posteriores)
        product(name: "iPhone 12 Pro", price: 1900,
            category: "iPhone", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "Pantalla Super Retina XDR de 6.1\", LiDAR Scanner, cámara triple. Chip A14 Bionic. 5G.",
            colors: [C.grafito, C.plata, C.oro, C.azul],
            storages: [S.g128, S.g256, S.g512]),

        // Precio corregido: 2139 → 1499 (no podía superar a generaciones posteriores)
        product(name: "iPhone 12", price: 1499,
            category: "iPhone", imageName: "iphone2",
            additionalImages: ["iphone1","iphone3","iphone2","iphone3"],
            description: "Pantalla OLED de 6.1\", 5G, A14 Bionic, cámara dual 12 MP. Diseño de aluminio con Ceramic Shield.",
            colors: [C.negro, C.blanco, C.rosa, C.verde, C.azul, C.productoRED],
            storages: [S.g64, S.g128, S.g256]),
    ]

    // =========================================================================
    // MARK: - iPad
    // REGLA: colores y storages EXACTOS por modelo — sin lista global
    //
    // AUDITORÍA: iPad Air M2 11" se subió de precio para mantener orden
    // creciente frente al iPad Pro 12.9" M1 (generación anterior superior).
    // =========================================================================
    private static let iPads: [SeedProduct] = [

        // iPad Pro M4 (mayo 2024) — solo Plata / Negro Espacial, mínimo 256GB
        product(name: "iPad Pro 13\" M4", price: 6963,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Tandem OLED Ultra Retina XDR de 13\". Chip M4. El iPad más delgado (5.1 mm). Compatible con Apple Pencil Pro y Magic Keyboard.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        product(name: "iPad Pro 11\" M4", price: 5355,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Tandem OLED Ultra Retina XDR de 11\". Chip M4. Diseño ultradelgado de 5.3 mm. Compatible con Apple Pencil Pro.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // Precio corregido: 4699 → 3950 (debe ser < iPad Air 13" M2 y < iPad Pro 11" M2)
        product(name: "iPad Air 11\" M2", price: 3950,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Liquid Retina de 11\". Chip M2. Compatible con Apple Pencil Pro y Magic Keyboard. Wi-Fi 6E.",
            colors: [C.azul, C.morado, C.luzEstelar, C.rosa],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // Precio corregido: 4283 → 4150 (debe quedar entre Air 11" y Pro 11" M2)
        product(name: "iPad Air 13\" M2", price: 4150,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Liquid Retina de 13\". Chip M2. Primera iPad Air de 13\". Wi-Fi 6E y Magic Keyboard compatible.",
            colors: [C.azul, C.morado, C.luzEstelar],
            storages: [S.g128, S.g256, S.g512, S.t1]),

        // iPad mini 7 (oct 2024) — Azul, Morado, Luz Estelar, Rosa
        product(name: "iPad mini 7", price: 2675,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Liquid Retina de 8.3\". Chip A17 Pro. Compatible con Apple Pencil Pro. El mini más potente.",
            colors: [C.azul, C.morado, C.luzEstelar, C.rosa],
            storages: [S.g128, S.g256, S.g512]),

        // iPad Pro M2 (oct 2022) — Plata / Gris Espacial
        product(name: "iPad Pro 12.9\" M2", price: 5087,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Liquid Retina XDR de 12.9\" con miniLED. Chip M2. ProMotion 120 Hz. Compatible con Apple Pencil 2ª gen.",
            colors: [C.plata, C.grisEspacial],
            storages: [S.g128, S.g256, S.g512, S.t1, S.t2]),

        // Precio corregido: 4283 → 4699 (debe superar a iPad Air 13" M2)
        product(name: "iPad Pro 11\" M2", price: 4699,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Liquid Retina de 11\". Chip M2. ProMotion 120 Hz. Compatible con Apple Pencil 2ª gen.",
            colors: [C.plata, C.grisEspacial],
            storages: [S.g128, S.g256, S.g512, S.t1, S.t2]),

        // iPad 10ª Gen (oct 2022) — Azul, Rosa, Amarillo, Plata · 64/256GB (solo 2 opciones)
        product(name: "iPad 10ª Gen", price: 1871,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Liquid Retina de 10.9\". Chip A14 Bionic. Diseño de bordes planos con USB-C. Compatible con Apple Pencil USB-C.",
            colors: [C.azul, C.rosa, C.amarillo, C.plata],
            storages: [S.g64, S.g256]),

        // iPad 9ª Gen (sep 2021) — solo Gris Espacial y Plata · 64/256GB
        product(name: "iPad 9ª Gen", price: 1495,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Retina de 10.2\". Chip A13 Bionic. Botón de inicio con Touch ID y Lightning. El iPad de entrada más popular.",
            colors: [C.grisEspacial, C.plata],
            storages: [S.g64, S.g256]),

        // iPad mini 6 (sep 2021) — Gris Espacial, Rosa, Morado, Luz Estelar · 64/256GB
        product(name: "iPad mini 6", price: 2407,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Liquid Retina de 8.3\". Chip A15 Bionic. Rediseño total con Touch ID lateral y USB-C. Compatible con Apple Pencil 2ª gen.",
            colors: [C.grisEspacial, C.rosa, C.morado, C.luzEstelar],
            storages: [S.g64, S.g256]),

        // iPad Pro M1 (abr 2021) — Plata / Gris Espacial
        product(name: "iPad Pro 12.9\" M1", price: 4283,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Liquid Retina XDR de 12.9\" con miniLED (primera generación). Chip M1. Thunderbolt / USB 4. Center Stage.",
            colors: [C.plata, C.grisEspacial],
            storages: [S.g128, S.g256, S.g512, S.t1, S.t2]),

        // iPad Air 5ª Gen M1 (mar 2022) — 5 colores
        product(name: "iPad Air 5ª Gen (M1)", price: 3091,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Liquid Retina de 10.9\". Chip M1. Primera iPad Air con 5G y Center Stage. Compatible con Apple Pencil 2ª gen.",
            colors: [C.azul, C.morado, C.rosa, C.luzEstelar, C.grisEspacial],
            storages: [S.g64, S.g256]),

        // iPad Air 4ª Gen (oct 2020) — Gris Espacial, Plata, Oro Rosa, Verde, Azul Cielo
        product(name: "iPad Air 4ª Gen", price: 2451,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Liquid Retina de 10.9\". Chip A14 Bionic. Primer Air con Touch ID lateral y USB-C. Compatible con Apple Pencil 2ª gen.",
            colors: [C.grisEspacial, C.plata, C.oroRosa, C.verde, C.cian],
            storages: [S.g64, S.g256]),

        // iPad mini 5ª Gen (mar 2019) — 4 colores · 64/256GB
        product(name: "iPad mini 5ª Gen", price: 1703,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Retina de 7.9\". Chip A12 Bionic. Compatible con Apple Pencil 1ª gen. Diseño clásico con botón de inicio.",
            colors: [C.grisEspacial, C.plata, C.oro, C.rosaClaro],
            storages: [S.g64, S.g256]),

        // iPad 8ª Gen (sep 2020) — 3 colores · 32/128GB
        product(name: "iPad 8ª Gen", price: 1275,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad","ipad01","ipad","ipad01"],
            description: "Pantalla Retina de 10.2\". Chip A12 Bionic con Neural Engine. Compatible con Smart Keyboard y Apple Pencil 1ª gen.",
            colors: [C.grisEspacial, C.plata, C.oro],
            storages: [S.g32, S.g128]),

        // iPad 7ª Gen (sep 2019) — 3 colores · 32/128GB
        product(name: "iPad 7ª Gen", price: 1059,
            category: "iPad", imageName: "ipad",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Retina de 10.2\". Chip A10 Fusion. El primer iPad con pantalla de 10.2\" y Smart Connector.",
            colors: [C.grisEspacial, C.plata, C.oro],
            storages: [S.g32, S.g128]),

        // iPad Air 3ª Gen (mar 2019) — 5 colores · 64/256GB
        product(name: "iPad Air 3ª Gen", price: 1811,
            category: "iPad", imageName: "ipad01",
            additionalImages: ["ipad01","ipad","ipad01","ipad"],
            description: "Pantalla Retina de 10.5\". Chip A12 Bionic. Compatible con Apple Pencil 1ª gen y Smart Keyboard.",
            colors: [C.grisEspacial, C.plata, C.oro, C.rosaClaro, C.cian],
            storages: [S.g64, S.g256]),
    ]

    // =========================================================================
    // MARK: - Mac
    // REGLA: colores exactos por línea de producto
    //   MacBook Air M4/M3 → Medianoche, Luz Estelar, Azul Cielo, Morado
    //   MacBook Air M2 → Medianoche, Luz Estelar, Gris Espacial, Plata
    //   MacBook Pro M3/M4/M5 → Plata, Negro Espacial (Space Black debut M3)
    //   MacBook Pro M1 → Plata, Gris Espacial
    //   iMac 24" M3 → 7 colores únicos
    //   Mac mini M4 Pro → Plata, Negro
    //   Mac mini M4/M2/M1, Mac Studio, Mac Pro → solo Plata
    //
    // AUDITORÍA: se reordenaron los precios de MacBook Pro 14"/16" (M1→M3→M4→M5),
    // MacBook Air 13"/15" (M2→M3→M4) y Mac mini (M1→M2→M4→M4 Pro) para que cada
    // generación posterior cueste más que la anterior dentro de su mismo formato.
    // =========================================================================
    private static let macs: [SeedProduct] = [

        // MacBook Pro M5 (2025)
        product(name: "MacBook Pro 16\" M5", price: 18755,
            category: "Mac", imageName: "macbook",
            additionalImages: ["macbook2","macbook3","macbook","macbook2"],
            description: "Pantalla Liquid Retina XDR de 16\" ProMotion 120 Hz. Chip M5 Max, hasta 128 GB de RAM unificada. Thunderbolt 5. Hasta 22 h de batería.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g512, S.t1, S.t2, S.t4]),

        product(name: "MacBook Pro 14\" M5", price: 13395,
            category: "Mac", imageName: "macbook2",
            additionalImages: ["macbook","macbook3","macbook2","macbook3"],
            description: "Pantalla Liquid Retina XDR de 14.2\" ProMotion 120 Hz. Chip M5 Pro, 24 GB de RAM unificada. Carga MagSafe 3. Thunderbolt 5.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g512, S.t1, S.t2]),

        // MacBook Air M4 (mar 2025) — 4 colores exclusivos
        // Precio corregido: 6963 → 7500 (debe superar al M3 15" equivalente)
        product(name: "MacBook Air 15\" M4", price: 7500,
            category: "Mac", imageName: "macbook3",
            additionalImages: ["macbook","macbook2","macbook3","macbook"],
            description: "Pantalla Liquid Retina de 15.3\". Chip M4, 16 GB RAM. Sin ventilador. Hasta 18 h de batería. Cámara Center Stage 12 MP.",
            colors: [C.medianoche, C.luzEstelar, C.plata, C.azulCielo],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // Precio corregido: 5355 → 6500 (debe superar al M3 13" equivalente)
        product(name: "MacBook Air 13\" M4", price: 6500,
            category: "Mac", imageName: "macbook",
            additionalImages: ["macbook2","macbook3","macbook","macbook3"],
            description: "Pantalla Liquid Retina de 13.6\". Chip M4, 16 GB RAM. El portátil más vendido del mundo. Soporte para dos monitores externos.",
            colors: [C.medianoche, C.luzEstelar, C.plata, C.azulCielo],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // MacBook Pro M4 (nov 2024)
        // Precio corregido: 16075 → 17500 (debe superar al M3 Max 16" corregido)
        product(name: "MacBook Pro 16\" M4 Pro", price: 17500,
            category: "Mac", imageName: "macbook2",
            additionalImages: ["macbook","macbook3","macbook2","macbook"],
            description: "Pantalla Liquid Retina XDR de 16\" ProMotion. Chip M4 Pro, 24 GB RAM. Thunderbolt 5. Hasta 24 h de batería.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g512, S.t1, S.t2]),

        // Precio sin cambio: 10715, ya queda > M3 Pro 14" corregido (9500) y < M5 14" (13395)
        product(name: "MacBook Pro 14\" M4 Pro", price: 10715,
            category: "Mac", imageName: "macbook3",
            additionalImages: ["macbook","macbook2","macbook3","macbook2"],
            description: "Pantalla Liquid Retina XDR de 14.2\" ProMotion. Chip M4 Pro, 24 GB RAM. Thunderbolt 5.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g512, S.t1, S.t2]),

        // Mac mini M4 (nov 2024)
        product(name: "Mac mini M4 Pro", price: 4819,
            category: "Mac", imageName: "desktopcomputer",
            additionalImages: ["desktopcomputer","imac","desktopcomputer","imac"],
            description: "Mac mini con chip M4 Pro, 24 GB RAM. 3× Thunderbolt 5. Rediseño histórico compacto de 12.7×12.7 cm.",
            colors: [C.plata, C.negro],
            storages: [S.g512, S.t1, S.t2]),

        // Precio corregido: 3211 → 3747 (debe superar a M1/M2, sus predecesores)
        product(name: "Mac mini M4", price: 3747,
            category: "Mac", imageName: "desktopcomputer",
            additionalImages: ["imac","desktopcomputer","imac","desktopcomputer"],
            description: "Mac mini con chip M4, 16 GB RAM. El Mac más pequeño de la historia. Thunderbolt 4. Precio de entrada histórico.",
            colors: [C.plata],
            storages: [S.g256, S.g512]),

        // Mac Studio M4 Max (mar 2025) — solo Plata
        product(name: "Mac Studio M4 Max", price: 21435,
            category: "Mac", imageName: "desktopcomputer",
            additionalImages: ["imac","desktopcomputer","imac","desktopcomputer"],
            description: "Rendimiento extremo. Chip M4 Max, 36 GB RAM unificada. Thunderbolt 5. Para videófilos, músicos y diseñadores 3D.",
            colors: [C.plata],
            storages: [S.g512, S.t1, S.t2]),

        // Mac Pro M4 Ultra (2025) — desde 1TB
        product(name: "Mac Pro M4 Ultra", price: 42876,
            category: "Mac", imageName: "desktopcomputer",
            additionalImages: ["imac","desktopcomputer","imac","desktopcomputer"],
            description: "El Mac más potente. Chip M4 Ultra, hasta 192 GB RAM unificada. Para rendering industrial, ML y postproducción.",
            colors: [C.plata],
            storages: [S.t1, S.t2, S.t4, S.t8]),

        // iMac 24" M3 (oct 2023) — 7 colores propios del iMac
        product(name: "iMac 24\" M3", price: 6963,
            category: "Mac", imageName: "imac",
            additionalImages: ["desktopcomputer","imac","desktopcomputer","imac"],
            description: "Todo-en-uno con pantalla Retina 4.5K de 24\". Chip M3, 8 GB RAM. Diseño ultrafino en 7 colores vibrantes. Cámara 12 MP Center Stage.",
            colors: [C.azuliMac, C.verdeiMac, C.rosaiMac, C.plata, C.amarilloiMac, C.naranjaiMac, C.moradoiMac],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // MacBook Pro M3 (nov 2023) — Space Black debut
        // Precio corregido: 18755 → 16075 (no podía igualar al M5 16", debe quedar entre M1 Max y M4 Pro)
        product(name: "MacBook Pro 16\" M3 Max", price: 16075,
            category: "Mac", imageName: "macbook3",
            additionalImages: ["macbook","macbook2","macbook3","macbook"],
            description: "Pantalla Liquid Retina XDR de 16\" ProMotion. Chip M3 Max. Disponible en el nuevo Negro Espacial exclusivo de los Pro.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g512, S.t1, S.t2]),

        // Precio corregido: 8571 → 9500 (debe superar al M1 Pro 14" corregido y quedar < M4 Pro)
        product(name: "MacBook Pro 14\" M3 Pro", price: 9500,
            category: "Mac", imageName: "macbook",
            additionalImages: ["macbook2","macbook3","macbook","macbook3"],
            description: "Pantalla Liquid Retina XDR de 14.2\" ProMotion. Chip M3 Pro. Disponible en Negro Espacial.",
            colors: [C.plata, C.negroEspacial],
            storages: [S.g512, S.t1, S.t2]),

        // MacBook Air M3 (mar 2024) — 4 colores
        // Precio sin cambio: 6963, ya queda > M2 15" (no existía variante 15" M2, base de comparación es M2 13")
        product(name: "MacBook Air 15\" M3", price: 6963,
            category: "Mac", imageName: "macbook",
            additionalImages: ["macbook2","macbook3","macbook","macbook2"],
            description: "Pantalla Liquid Retina de 15.3\". Chip M3, 8 GB RAM. Sin ventilador. Soporte para dos pantallas externas.",
            colors: [C.medianoche, C.luzEstelar, C.plata, C.grisEspacial],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // Precio corregido: 5355 → 5891 (debe superar al M2 13" corregido)
        product(name: "MacBook Air 13\" M3", price: 5891,
            category: "Mac", imageName: "macbook2",
            additionalImages: ["macbook","macbook3","macbook2","macbook3"],
            description: "Pantalla Liquid Retina de 13.6\". Chip M3, 8 GB RAM. Soporte para dos pantallas externas simultáneas.",
            colors: [C.medianoche, C.luzEstelar, C.plata, C.grisEspacial],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // MacBook Air M2 (jun 2022) — 4 colores propios
        // Precio corregido: 5891 → 5355 (no podía superar a M3 13", su sucesor)
        product(name: "MacBook Air 13\" M2", price: 5355,
            category: "Mac", imageName: "macbook3",
            additionalImages: ["macbook","macbook2","macbook3","macbook"],
            description: "Pantalla Liquid Retina de 13.6\". Chip M2. Rediseño total con muesca, MagSafe 3 y sin ventilador.",
            colors: [C.medianoche, C.luzEstelar, C.grisEspacial, C.plata],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // MacBook Pro M1 (oct 2021) — Plata / Gris Espacial (no Space Black aún)
        // Precio corregido: 10715 → 8571 (no podía igualar/superar a M3 Pro 14", su sucesor)
        product(name: "MacBook Pro 14\" M1 Pro", price: 8571,
            category: "Mac", imageName: "macbook",
            additionalImages: ["macbook2","macbook3","macbook","macbook3"],
            description: "Pantalla Liquid Retina XDR de 14.2\" ProMotion. Chip M1 Pro. HDMI, SD y MagSafe 3. Primera generación Pro con Apple Silicon.",
            colors: [C.plata, C.grisEspacial],
            storages: [S.g512, S.t1, S.t2]),

        // Precio sin cambio: 13395, ya queda < M3 Max 16" corregido (16075)
        product(name: "MacBook Pro 16\" M1 Max", price: 13395,
            category: "Mac", imageName: "macbook2",
            additionalImages: ["macbook","macbook3","macbook2","macbook"],
            description: "Pantalla Liquid Retina XDR de 16.2\" ProMotion. Chip M1 Max, hasta 64 GB RAM. Primera generación con Apple Silicon Pro Max.",
            colors: [C.plata, C.grisEspacial],
            storages: [S.t1, S.t2, S.t4]),

        // Mac mini M2 / M1 — solo Plata
        // Precio corregido: 3747 → 3211 (debe quedar entre M1 corregido y M4 corregido)
        product(name: "Mac mini M2", price: 3211,
            category: "Mac", imageName: "desktopcomputer",
            additionalImages: ["imac","desktopcomputer","imac","desktopcomputer"],
            description: "Mac mini con chip M2, 8 GB RAM. Dos puertos Thunderbolt 4. Segunda generación Apple Silicon compacta.",
            colors: [C.plata],
            storages: [S.g256, S.g512, S.t1, S.t2]),

        // Precio corregido: 3747 → 2900 (no podía igualar a M2, su sucesor)
        product(name: "Mac mini M1", price: 2900,
            category: "Mac", imageName: "desktopcomputer",
            additionalImages: ["imac","desktopcomputer","imac","desktopcomputer"],
            description: "Mac mini con chip M1, 8 GB RAM. El primer Mac con Apple Silicon. Rendimiento revolucionario en formato compacto.",
            colors: [C.plata],
            storages: [S.g256, S.g512, S.t1, S.t2]),
    ]

    // =========================================================================
    // MARK: - Apple Watch
    // REGLA: colores exactos por variante, sin lista global
    //   Series 10 aluminio → Plata, Negro Jet, Oro Rosa
    //   Ultra 2 / Ultra 3 → solo Titanio Natural
    //   SE 2 / SE 3 → Medianoche, Luz Estelar, Plata
    //   Series 9 aluminio → Medianoche, Luz Estelar, Rosa, Rojo, Plata
    //   Series 8 → Medianoche, Luz Estelar, Rojo, Plata
    //   Series 7 → Medianoche, Luz Estelar, Verde, Azul, Rojo
    //   Nike → Negro, Plata
    //   Hermès → Plata (acero inoxidable)
    //
    // AUDITORÍA: las Series 6-11 y SE1-3 y Ultra2-3 tenían precios duplicados
    // entre generaciones (sin crecimiento). Se escalonaron para reflejar
    // incrementos reales entre lanzamientos.
    // =========================================================================
    private static let watches: [SeedProduct] = [

        // ⚠️ Series 11 y Ultra 3 y SE 3 son especulativos — marcados en descripción
        // Precio corregido: 2139 → 2350 (debe superar a Series 10)
        product(name: "Apple Watch Series 11", price: 2350,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "[Especulativo 2025] Sucesor del Series 10. Detección de apnea del sueño mejorada, sensores de salud avanzados y chip S11.",
            colors: [C.medianoche, C.luzEstelar, C.rosa, C.plata],
            storages: []),

        // Precio corregido: 4283 → 4600 (debe superar a Ultra 2)
        product(name: "Apple Watch Ultra 3", price: 4600,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "[Especulativo 2025] Sucesor del Ultra 2. Titanio, resistencia extrema certificada, batería de 3+ días y nuevos sensores de salud.",
            colors: [C.titNatural],
            storages: []),

        // Precio corregido: 1335 → 1450 (debe superar a SE 2)
        product(name: "Apple Watch SE 3", price: 1450,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "[Especulativo 2025] Sucesor del SE 2. Fitness esencial con GPS, Crash Detection y chip S9 actualizado.",
            colors: [C.medianoche, C.luzEstelar, C.plata],
            storages: []),

        // Series 10 (sep 2024) — aluminio: Plata, Negro Jet, Oro Rosa
        // Precio sin cambio: 2139, ya queda > Series 9 corregido (1950) y < Series 11 corregido
        product(name: "Apple Watch Series 10", price: 2139,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "La pantalla más grande y delgada del Apple Watch. Detección de apnea del sueño. Carga ultrarrápida. Chip S10.",
            colors: [C.plata, C.negro, C.oroRosa],
            storages: []),

        // Ultra 2 (sep 2023)
        // Precio sin cambio: 4283, ya queda < Ultra 3 corregido
        product(name: "Apple Watch Ultra 2", price: 4283,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Caja de titanio aeroespacial. Hasta 60 h de batería. Resistencia extrema MIL-STD-810H. Display Always-On 2000 nits. Chip S9.",
            colors: [C.titNatural],
            storages: []),

        // Series 9 (sep 2023)
        // Precio corregido: 2139 → 1950 (debe superar a Series 8 corregido y quedar < Series 10)
        product(name: "Apple Watch Series 9", price: 1950,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Doble Toque para controlar con una mano. Chip S9, pantalla hasta 2000 nits. Temperatura corporal y ECG.",
            colors: [C.medianoche, C.luzEstelar, C.rosa, C.rojo, C.plata],
            storages: []),

        // SE 2 (sep 2022)
        // Precio sin cambio: 1335, ya queda > SE1 corregido y < SE3 corregido
        product(name: "Apple Watch SE 2", price: 1335,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Fitness esencial con GPS, Crash Detection y detección de caídas. Chip S8. La opción más económica del Watch actual.",
            colors: [C.medianoche, C.luzEstelar, C.plata],
            storages: []),

        // Series 8 (sep 2022)
        // Precio corregido: 2139 → 1800 (debe superar a Series 7 corregido y quedar < Series 9)
        product(name: "Apple Watch Series 8", price: 1800,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Sensor de temperatura corporal y Crash Detection. ECG y oxígeno en sangre. Chip S8.",
            colors: [C.medianoche, C.luzEstelar, C.rojo, C.plata],
            storages: []),

        // Series 7 (oct 2021)
        // Precio corregido: 1871 → 1650 (debe superar a Series 6 corregido y quedar < Series 8)
        product(name: "Apple Watch Series 7", price: 1650,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Pantalla más grande con bordes curvos. ECG, oxígeno en sangre y carga rápida. Chip S7.",
            colors: [C.medianoche, C.luzEstelar, C.verde, C.azul, C.rojo],
            storages: []),

        // SE 1 (sep 2020)
        // Precio corregido: 1335 → 1200 (no podía igualar a SE2, su sucesor)
        product(name: "Apple Watch SE 1", price: 1200,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "El Apple Watch SE original. GPS y detección de caídas. Chip S5. Buena opción de entrada económica.",
            colors: [C.grisEspacial, C.plata, C.oro],
            storages: []),

        // Series 6 (sep 2020)
        // Precio corregido: 1871 → 1500 (no podía igualar a Series 7, su sucesor)
        product(name: "Apple Watch Series 6", price: 1500,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Primer Apple Watch con sensor de oxígeno en sangre (SpO2). Always-On Display de segunda generación. Chip S6.",
            colors: [C.azul, C.rojo, C.negro, C.plata, C.oro],
            storages: []),

        // Ediciones especiales
        product(name: "Apple Watch Hermès Series 9", price: 4819,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Edición de lujo en colaboración con Hermès. Caja de acero inoxidable con correas de cuero artesanal francés exclusivas.",
            colors: [C.plata],
            storages: []),

        // Precio corregido: 2139 → 2040 (debe quedar entre Series 9 y Series 10)
        product(name: "Apple Watch Nike Series 9", price: 2040,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Edición deportiva Nike con correa Nike Sport Band y watchfaces exclusivos Nike. Chip S9.",
            colors: [C.negro, C.plata],
            storages: []),

        // Precio corregido: 2139 → 1875 (debe quedar entre Series 8 y Series 9)
        product(name: "Apple Watch Nike Series 8", price: 1875,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Edición deportiva Nike con correa exclusiva y watchfaces Nike. Crash Detection. Chip S8.",
            colors: [C.negro, C.plata],
            storages: []),

        product(name: "Apple Watch Hermès Series 8", price: 4283,
            category: "Apple Watch", imageName: "applewatch",
            additionalImages: ["applewatch","applewatch","applewatch","applewatch"],
            description: "Edición Hermès con Series 8. Acero inoxidable y correas de cuero artesanal francés.",
            colors: [C.plata],
            storages: []),
    ]

    // =========================================================================
    // MARK: - AirPods
    // ERRORES CORREGIDOS:
    //   ✅ Eliminado "AirPods Max Space Gray" — no existe en USB-C
    //   ✅ Añadido "AirPods Max Lightning" (2020) con colores correctos
    //   ✅ AirPods Max USB-C: 5 colores reales (Azul Medianoche, Luz Estelar, Verde, Naranja, Morado)
    // =========================================================================
    private static let airpods: [SeedProduct] = [

        // ⚠️ AirPods Pro 3 — especulativo
        product(name: "AirPods Pro 3", price: 1335,
            category: "AirPods", imageName: "airpodspro",
            additionalImages: ["airpodspro","airpods","airpodspro","airpods"],
            description: "[Especulativo 2025] Sucesor de los AirPods Pro 2. Chip H3, sensores de salud auditiva mejorados y cancelación de ruido de tercera generación.",
            colors: [C.blanco],
            storages: []),

        // AirPods Pro 2 USB-C (sep 2023)
        product(name: "AirPods Pro 2 USB-C", price: 1227,
            category: "AirPods", imageName: "airpodspro",
            additionalImages: ["airpodspro","airpods","airpodspro","airpods"],
            description: "Cancelación activa de ruido H2. Audio Adaptivo y Volumen Adaptivo. Estuche USB-C con MagSafe. Modo Transparencia conversacional.",
            colors: [C.blanco],
            storages: []),

        // AirPods Pro 2 Lightning (sep 2022)
        product(name: "AirPods Pro 2 Lightning", price: 1335,
            category: "AirPods", imageName: "airpodspro",
            additionalImages: ["airpodspro","airpods","airpodspro","airpods"],
            description: "Cancelación activa de ruido de segunda generación. Chip H2. Audio Espacial Personalizado. Estuche con altavoz y correa.",
            colors: [C.blanco],
            storages: []),

        // AirPods Max USB-C (ene 2024) — 5 colores correctos, NO Space Gray
        product(name: "AirPods Max USB-C", price: 2943,
            category: "AirPods", imageName: "airpods",
            additionalImages: ["airpods","airpodspro","airpods","airpodspro"],
            description: "Auriculares over-ear premium con cancelación activa de ruido. Puerto USB-C. Audio Espacial dinámico. Malla de tela y aluminio anodizado.",
            colors: [C.azulMedianoche, C.luzEstelar, C.verde, C.naranja, C.morado],
            storages: []),

        // AirPods Max Lightning (nov 2020) — colores originales: Plata, Gris Espacial, Verde, Celeste, Rosa
        product(name: "AirPods Max (Lightning)", price: 2675,
            category: "AirPods", imageName: "airpods",
            additionalImages: ["airpodspro","airpods","airpodspro","airpods"],
            description: "Primera versión con puerto Lightning. Cancelación activa de ruido original, Audio Espacial y chip H1. 5 colores originales.",
            colors: [C.plata, C.grisEspacial, C.verdeAM, C.celesteAM, C.rosaAM],
            storages: []),

        // AirPods 4 con ANC (sep 2024)
        product(name: "AirPods 4 con ANC", price: 959,
            category: "AirPods", imageName: "airpods",
            additionalImages: ["airpods","airpodspro","airpods","airpodspro"],
            description: "AirPods 4 con Cancelación Activa de Ruido y modo Transparencia. Chip H2. Diseño abierto sin almohadillas.",
            colors: [C.blanco],
            storages: []),

        product(name: "AirPods 4", price: 691,
            category: "AirPods", imageName: "airpods",
            additionalImages: ["airpods","airpodspro","airpods","airpodspro"],
            description: "AirPods 4 base. Nuevo diseño ergonómico con mejor ajuste. Audio Espacial Personalizado. Chip H2.",
            colors: [C.blanco],
            storages: []),

        // AirPods 3ª Gen (oct 2021)
        product(name: "AirPods 3ª Gen", price: 691,
            category: "AirPods", imageName: "airpods",
            additionalImages: ["airpodspro","airpods","airpodspro","airpods"],
            description: "Diseño inspirado en los Pro sin almohadillas. Audio Espacial dinámico y resistencia IPX4. Chip H1.",
            colors: [C.blanco],
            storages: []),

        product(name: "AirPods 2ª Gen", price: 531,
            category: "AirPods", imageName: "airpods",
            additionalImages: ["airpods","airpodspro","airpods","airpodspro"],
            description: "Los auriculares inalámbricos clásicos de Apple. Chip H1, activación Hey Siri. La opción más económica.",
            colors: [C.blanco],
            storages: []),

        product(name: "AirPods Pro 1ª Gen", price: 959,
            category: "AirPods", imageName: "airpodspro",
            additionalImages: ["airpodspro","airpods","airpodspro","airpods"],
            description: "El AirPods Pro original. Cancelación activa de primera generación con almohadillas de silicona. Chip H1.",
            colors: [C.blanco],
            storages: []),
    ]

    // =========================================================================
    // MARK: - TV y Casa
    // =========================================================================
    private static let tvCasa: [SeedProduct] = [

        product(name: "Apple TV 4K (2024) WiFi", price: 531,
            category: "TV y Casa", imageName: "appletvbox",
            additionalImages: ["appletvbox","homepod","appletvbox","homepod"],
            description: "Streaming 4K a 60fps con WiFi 6E y HDR10+. Chip A15 Bionic. Siri Remote con USB-C. El streamer más poderoso de Apple.",
            colors: [ColorOption(name: "Negro", hexColor: "#1C1C1E")],
            storages: []),

        // Nombre oficial corregido: "Wi-Fi + Ethernet"
        product(name: "Apple TV 4K (2024) Wi-Fi + Ethernet", price: 638,
            category: "TV y Casa", imageName: "appletvbox",
            additionalImages: ["appletvbox","homepod","appletvbox","homepod"],
            description: "Streaming 4K con puerto Ethernet Gigabit y WiFi 6E. Ideal para instalaciones permanentes con máxima estabilidad de red.",
            colors: [ColorOption(name: "Negro", hexColor: "#1C1C1E")],
            storages: []),

        product(name: "Apple TV HD", price: 316,
            category: "TV y Casa", imageName: "appletvbox",
            additionalImages: ["appletvbox","homepod","appletvbox","homepod"],
            description: "Streaming en 1080p con chip A8. La entrada más económica al ecosistema Apple TV con AirPlay y HomeKit.",
            colors: [ColorOption(name: "Negro", hexColor: "#1C1C1E")],
            storages: []),

        product(name: "Apple TV 4K (2022)", price: 531,
            category: "TV y Casa", imageName: "appletvbox",
            additionalImages: ["appletvbox","homepod","appletvbox","homepod"],
            description: "Apple TV 4K de tercera generación. Chip A15, WiFi 6 y HDR10+. Siri Remote rediseñado con clickpad.",
            colors: [ColorOption(name: "Negro", hexColor: "#1C1C1E")],
            storages: []),

        // HomePod 2ª Gen — Blanco y Medianoche
        product(name: "HomePod 2ª Gen", price: 1603,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "Altavoz inteligente de alta fidelidad con sonido envolvente Dolby Atmos. Chip S7. Sensor de temperatura y humedad. Hub de HomeKit.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0"), ColorOption(name: "Medianoche", hexColor: "#222930")],
            storages: []),

        product(name: "HomePod mini Blanco", price: 531,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "Altavoz inteligente compacto con chip S5. Intercom, automatizaciones del hogar y audio 360°. Hub de HomeKit.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "HomePod mini Medianoche", price: 531,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "HomePod mini en color Medianoche. Centro del hogar inteligente con chip S5 y audio de 360°.",
            colors: [ColorOption(name: "Medianoche", hexColor: "#222930")],
            storages: []),

        product(name: "HomePod mini Naranja", price: 531,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "HomePod mini en color Naranja. Diseño colorido para el hogar inteligente con chip S5.",
            colors: [ColorOption(name: "Naranja", hexColor: "#FF9F0A")],
            storages: []),

        product(name: "HomePod mini Amarillo", price: 531,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "HomePod mini en color Amarillo. Centro del hogar inteligente con chip S5.",
            colors: [ColorOption(name: "Amarillo", hexColor: "#FFD60A")],
            storages: []),

        product(name: "HomePod mini Azul", price: 531,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "HomePod mini en color Azul. Centro del hogar inteligente con chip S5.",
            colors: [ColorOption(name: "Azul", hexColor: "#5AC8FA")],
            storages: []),

        product(name: "HomePod mini Rojo", price: 531,
            category: "TV y Casa", imageName: "homepod",
            additionalImages: ["homepod","appletvbox","homepod","appletvbox"],
            description: "HomePod mini edición Product RED. Una parte de la venta apoya al Fondo Global contra el SIDA.",
            colors: [ColorOption(name: "Rojo", hexColor: "#BF0000")],
            storages: []),
    ]

    // =========================================================================
    // MARK: - Accesorios
    // =========================================================================
    private static let accesorios: [SeedProduct] = [

        // Magic Keyboard — Plata y Gris Espacial (no Oro Rosa en este modelo)
        product(name: "Magic Keyboard con Touch ID USB-C", price: 1067,
            category: "Accesorios", imageName: "keyboard",
            additionalImages: ["keyboard","mouse2","trackpad","keyboard"],
            description: "Teclado inalámbrico con Touch ID y puerto USB-C. Compatible con Mac, iPad e iPhone con iOS 16+.",
            colors: [C.plata, C.grisEspacial],
            storages: []),

        product(name: "Magic Keyboard Numérico USB-C", price: 1335,
            category: "Accesorios", imageName: "keyboard",
            additionalImages: ["keyboard","mouse2","trackpad","keyboard"],
            description: "Teclado extendido con teclado numérico, Touch ID y USB-C. Diseñado para Mac con chip Apple Silicon.",
            colors: [C.plata, C.grisEspacial],
            storages: []),

        // Magic Mouse — Plata y Negro
        product(name: "Magic Mouse USB-C", price: 531,
            category: "Accesorios", imageName: "mouse2",
            additionalImages: ["mouse2","keyboard","trackpad","mouse2"],
            description: "Ratón inalámbrico multitáctil con superficie de vidrio Multi-Touch. Puerto USB-C para carga.",
            colors: [C.plata, C.negro],
            storages: []),

        // Magic Trackpad — Plata y Negro
        product(name: "Magic Trackpad USB-C", price: 691,
            category: "Accesorios", imageName: "trackpad",
            additionalImages: ["trackpad","keyboard","mouse2","trackpad"],
            description: "Trackpad inalámbrico con Force Touch y retroalimentación háptica. La superficie multitáctil más grande. USB-C.",
            colors: [C.plata, C.negro],
            storages: []),

        // Apple Pencil Pro (mayo 2024) — solo iPad Pro M4, Air M2, mini 7
        product(name: "Apple Pencil Pro", price: 691,
            category: "Accesorios", imageName: "applepencil",
            additionalImages: ["applepencil","applepencil","applepencil","applepencil"],
            description: "El Apple Pencil más avanzado. Squeeze, rotación y Find My. Compatible con iPad Pro M4 (11\"/13\"), iPad Air M2 (11\"/13\") e iPad mini 7.",
            colors: [C.blanco],
            storages: []),

        // Apple Pencil 2ª Gen — iPad Pro 2018-2022, Air 4ª/5ª Gen, mini 6
        product(name: "Apple Pencil 2ª Gen", price: 691,
            category: "Accesorios", imageName: "applepencil",
            additionalImages: ["applepencil","applepencil","applepencil","applepencil"],
            description: "Carga y emparejamiento magnético. Doble toque para cambiar herramientas. Compatible con iPad Pro (2018-2022), Air 4ª y 5ª Gen, mini 6.",
            colors: [C.blanco],
            storages: []),

        // Apple Pencil USB-C — iPad 10ª gen, mini 6, Air M2, Pro M4
        product(name: "Apple Pencil USB-C", price: 423,
            category: "Accesorios", imageName: "applepencil",
            additionalImages: ["applepencil","applepencil","applepencil","applepencil"],
            description: "Carga deslizando la tapa USB-C. La opción más económica. Compatible con iPad 10ª gen, mini 6, Air M2 e iPad Pro M4.",
            colors: [C.blanco],
            storages: []),

        // Apple Pencil 1ª Gen — iPad 9ª gen y anteriores, mini 5ª gen, Air 3ª gen
        product(name: "Apple Pencil 1ª Gen", price: 531,
            category: "Accesorios", imageName: "applepencil",
            additionalImages: ["applepencil","applepencil","applepencil","applepencil"],
            description: "Apple Pencil original con conector Lightning. Compatible con iPad 9ª gen y anteriores, mini 5ª gen y Air 3ª gen.",
            colors: [C.blanco],
            storages: []),

        // Teclados iPad — colores reales del producto
        product(name: "Magic Keyboard para iPad Pro M4 13\"", price: 1871,
            category: "Accesorios", imageName: "keyboard",
            additionalImages: ["keyboard","ipad","keyboard","ipad"],
            description: "Magic Keyboard de aluminio con trackpad Force Touch. Exclusivo para iPad Pro M4 de 13\". Puerto USB-C pass-through para carga.",
            colors: [C.blanco, C.negro],
            storages: []),

        product(name: "Magic Keyboard para iPad Pro M4 11\"", price: 1603,
            category: "Accesorios", imageName: "keyboard",
            additionalImages: ["keyboard","ipad","keyboard","ipad"],
            description: "Magic Keyboard de aluminio con trackpad Force Touch. Exclusivo para iPad Pro M4 de 11\". Puerto USB-C pass-through.",
            colors: [C.blanco, C.negro],
            storages: []),

        product(name: "Magic Keyboard Folio iPad 10ª Gen", price: 1067,
            category: "Accesorios", imageName: "keyboard",
            additionalImages: ["keyboard","ipad01","keyboard","ipad01"],
            description: "Teclado con trackpad y cubierta trasera protectora. Exclusivo para iPad 10ª generación. Smart Connector.",
            colors: [C.blanco],
            storages: []),

        product(name: "Smart Keyboard para iPad 9ª Gen", price: 638,
            category: "Accesorios", imageName: "keyboard",
            additionalImages: ["keyboard","ipad01","keyboard","ipad01"],
            description: "Teclado inteligente plegable para iPad 9ª generación y anteriores. Lightning + Smart Connector. Sin necesidad de carga.",
            colors: [C.negro],
            storages: []),

        // AirTag
        product(name: "AirTag", price: 155,
            category: "Accesorios", imageName: "airtag",
            additionalImages: ["airtag","airtag","airtag","airtag"],
            description: "Localizador Bluetooth con Precisión espacial Ultra Wideband. Batería CR2032 reemplazable. Resistente al agua IPX7.",
            colors: [ColorOption(name: "Blanco/Acero", hexColor: "#F0F0F0")],
            storages: []),

        product(name: "AirTag 4 Pack", price: 531,
            category: "Accesorios", imageName: "airtag",
            additionalImages: ["airtag","airtag","airtag","airtag"],
            description: "Pack de 4 localizadores AirTag. Protege llaves, billetera, mochila y maleta a la vez.",
            colors: [ColorOption(name: "Blanco/Acero", hexColor: "#F0F0F0")],
            storages: []),

        // Cables
        product(name: "Cable USB-C a USB-C 1m", price: 102,
            category: "Accesorios", imageName: "cable",
            additionalImages: ["cable","adapter","cable","adapter"],
            description: "Cable trenzado USB-C a USB-C de 1 metro. Compatible con iPhone 15/16/17, iPad Pro, iPad Air M2, Mac y cargadores MagSafe.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "Cable USB-C a Lightning 1m", price: 102,
            category: "Accesorios", imageName: "cable",
            additionalImages: ["cable","adapter","cable","adapter"],
            description: "Cable USB-C a Lightning de 1 metro. Para cargar rápido iPhone 14 y anteriores, AirPods con estuche Lightning.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "Cable Thunderbolt 4 Pro 1m", price: 263,
            category: "Accesorios", imageName: "cable",
            additionalImages: ["cable","adapter","cable","adapter"],
            description: "Cable Thunderbolt 4 blindado de 1 metro. Hasta 40 Gb/s de transferencia, 100W de carga y video 8K.",
            colors: [ColorOption(name: "Negro", hexColor: "#1C1C1E")],
            storages: []),

        // Adaptadores
        product(name: "Adaptador Lightning a 3.5mm", price: 48,
            category: "Accesorios", imageName: "adapter",
            additionalImages: ["adapter","cable","adapter","cable"],
            description: "Adaptador oficial para auriculares de 3.5mm en iPhone con Lightning. Imprescindible para iPhone 7 al 14.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "Adaptador USB-C Multipuerto", price: 423,
            category: "Accesorios", imageName: "adapter",
            additionalImages: ["adapter","cable","adapter","cable"],
            description: "Adaptador USB-C Digital AV Multipuerto. Salida HDMI hasta 4K 60Hz, USB-A 3.0 y USB-C pass-through de carga.",
            colors: [ColorOption(name: "Plata", hexColor: "#E5E5EA")],
            storages: []),

        // Cargadores
        product(name: "Cargador USB-C 20W", price: 155,
            category: "Accesorios", imageName: "adapter",
            additionalImages: ["adapter","cable","adapter","cable"],
            description: "Cargador compacto USB-C de 20W con carga rápida. Para iPhone 8 o posterior, iPad mini y AirPods Pro.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "Cargador USB-C 30W", price: 263,
            category: "Accesorios", imageName: "adapter",
            additionalImages: ["adapter","cable","adapter","cable"],
            description: "Cargador USB-C de 30W. Carga rápida para iPhone, iPad Air, iPad mini y MacBook Air.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "Cargador USB-C 67W", price: 531,
            category: "Accesorios", imageName: "adapter",
            additionalImages: ["adapter","cable","adapter","cable"],
            description: "Cargador USB-C de 67W de alta potencia. Para MacBook Pro 14\", iPad Pro y carga rápida de iPhone.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        product(name: "Base MagSafe Duo", price: 852,
            category: "Accesorios", imageName: "adapter",
            additionalImages: ["adapter","cable","adapter","cable"],
            description: "Carga inalámbrica simultánea para iPhone MagSafe (hasta 15W) y Apple Watch. Diseño plegable para viaje.",
            colors: [ColorOption(name: "Blanco", hexColor: "#F5F5F0")],
            storages: []),

        // Fundas
        product(name: "Funda FineWoven iPhone 17 Pro Max", price: 316,
            category: "Accesorios", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone2"],
            description: "Funda de tejido FineWoven con MagSafe para iPhone 17 Pro Max. Microtexturas suaves y acabado premium.",
            colors: [C.negro, C.verdeAlpino, C.morado, C.naranja],
            storages: []),

        product(name: "Funda Silicona iPhone 17", price: 263,
            category: "Accesorios", imageName: "iphone1",
            additionalImages: ["iphone2","iphone3","iphone1","iphone3"],
            description: "Funda de silicona suave con interior de microfibra y MagSafe para iPhone 17. Agarre cómodo.",
            colors: [C.negro, C.blanco, C.rosa, C.azul, C.verde],
            storages: []),
    ]

    // =========================================================================
    // MARK: - Ecosistemas
    // =========================================================================
    static let ecosistemas: [String: [String]] = [
        "Ecosistema 2021": [
            "iPhone 13", "iPhone 13 Mini", "iPhone 13 Pro", "iPhone 13 Pro Max",
            "iPad 9ª Gen", "iPad mini 6", "iPad Pro 12.9\" M1",
            "MacBook Pro 14\" M1 Pro", "MacBook Pro 16\" M1 Max", "Mac mini M1",
            "AirPods 3ª Gen", "Apple Watch Series 7",
            "Apple Pencil 1ª Gen", "Smart Keyboard para iPad 9ª Gen", "Cargador USB-C 20W"
        ],
        "Ecosistema 2022": [
            "iPhone 14", "iPhone 14 Plus", "iPhone 14 Pro", "iPhone 14 Pro Max",
            "iPhone SE (3ª Gen)",
            "iPad 10ª Gen", "iPad Pro 11\" M2", "iPad Pro 12.9\" M2", "iPad Air 5ª Gen (M1)",
            "MacBook Air 13\" M2", "Mac mini M2",
            "AirPods Pro 2 Lightning", "Apple Watch Series 8", "Apple Watch SE 2",
            "Apple Pencil 2ª Gen", "Magic Keyboard Folio iPad 10ª Gen", "Base MagSafe Duo"
        ],
        "Ecosistema 2023": [
            "iPhone 15", "iPhone 15 Plus", "iPhone 15 Pro", "iPhone 15 Pro Max",
            "iMac 24\" M3",
            "MacBook Air 15\" M3", "MacBook Air 13\" M3",
            "MacBook Pro 14\" M3 Pro", "MacBook Pro 16\" M3 Max",
            "AirPods Pro 2 USB-C", "Apple Watch Series 9", "Apple Watch Ultra 2",
            "Apple Pencil USB-C", "Cable USB-C a USB-C 1m"
        ],
        "Ecosistema 2024": [
            "iPhone 16", "iPhone 16 Plus", "iPhone 16 Pro", "iPhone 16 Pro Max",
            "iPad Air 11\" M2", "iPad Air 13\" M2",
            "iPad Pro 11\" M4", "iPad Pro 13\" M4", "iPad mini 7",
            "MacBook Air 13\" M4", "MacBook Air 15\" M4",
            "MacBook Pro 14\" M4 Pro", "MacBook Pro 16\" M4 Pro",
            "Mac mini M4", "Mac mini M4 Pro",
            "AirPods 4", "AirPods 4 con ANC", "AirPods Max USB-C",
            "Apple Watch Series 10",
            "Apple Pencil Pro",
            "Magic Keyboard para iPad Pro M4 11\"", "Magic Keyboard para iPad Pro M4 13\""
        ],
        "Ecosistema Actual 2025-2026": [
            "iPhone 16e", "iPhone 17e", "iPhone 17", "iPhone Air",
            "iPhone 17 Pro", "iPhone 17 Pro Max",
            "Mac mini M4", "Mac mini M4 Pro",
            "Mac Studio M4 Max", "Mac Pro M4 Ultra",
            "MacBook Air 13\" M4", "MacBook Air 15\" M4",
            "MacBook Pro 14\" M5", "MacBook Pro 16\" M5",
            "AirPods Pro 3",
            "Apple Watch Series 11", "Apple Watch Ultra 3", "Apple Watch SE 3",
            "Magic Mouse USB-C", "Magic Trackpad USB-C",
            "Magic Keyboard con Touch ID USB-C", "Magic Keyboard Numérico USB-C"
        ]
    ]

    // MARK: - Helpers
    static func recomendar(para nombreProducto: String) -> [String] {
        for (_, productos) in ecosistemas {
            if productos.contains(nombreProducto) {
                return productos.filter { $0 != nombreProducto }
            }
        }
        return []
    }

    static var products: [SeedProduct] { seedProducts }
}
