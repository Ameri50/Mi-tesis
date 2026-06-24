import Foundation

// MARK: - RepairData
struct RepairData {
    static let parts: [RepairPart] = [

        // MARK: ══ iPhone ══

        // MARK: - iPhone 12
        RepairPart(
            name: "Pantalla iPhone 12",
            price: 800,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 12"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 12",
            price: 350,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 12"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 12",
            price: 280,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 12"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 12",
            price: 220,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 12"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 12",
            price: 350,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 12"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 12",
            price: 200,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 12"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 12",
            price: 220,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 12"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 12",
            price: 230,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 12"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 12",
            price: 260,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 12"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 12 Pro
        RepairPart(
            name: "Pantalla iPhone 12 Pro",
            price: 950,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 12 Pro",
            price: 380,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 12 Pro",
            price: 310,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 12 Pro",
            price: 240,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 12 Pro",
            price: 380,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 12 Pro",
            price: 215,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 12 Pro",
            price: 235,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 12 Pro",
            price: 245,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 12 Pro",
            price: 285,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 12 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 12 Pro Max
        RepairPart(
            name: "Pantalla iPhone 12 Pro Max",
            price: 1150,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 12 Pro Max",
            price: 420,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 12 Pro Max",
            price: 350,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 12 Pro Max",
            price: 270,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 12 Pro Max",
            price: 420,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 12 Pro Max",
            price: 230,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 12 Pro Max",
            price: 255,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 12 Pro Max",
            price: 265,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 12 Pro Max",
            price: 320,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 12 Pro Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 13 Mini
        RepairPart(
            name: "Pantalla iPhone 13 Mini",
            price: 800,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 13 Mini",
            price: 340,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 13 Mini",
            price: 260,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 13 Mini",
            price: 210,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 13 Mini",
            price: 340,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 13 Mini",
            price: 195,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 13 Mini",
            price: 210,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 13 Mini",
            price: 220,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 13 Mini",
            price: 250,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 13 Mini"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 13
        RepairPart(
            name: "Pantalla iPhone 13",
            price: 950,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 13"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 13",
            price: 370,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 13"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 13",
            price: 300,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 13"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 13",
            price: 235,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 13"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 13",
            price: 370,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 13"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 13",
            price: 210,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 13"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 13",
            price: 230,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 13"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 13",
            price: 240,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 13"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 13",
            price: 275,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 13"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 13 Pro
        RepairPart(
            name: "Pantalla iPhone 13 Pro",
            price: 1100,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 13 Pro",
            price: 400,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 13 Pro",
            price: 330,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 13 Pro",
            price: 255,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 13 Pro",
            price: 400,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 13 Pro",
            price: 225,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 13 Pro",
            price: 248,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 13 Pro",
            price: 258,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 13 Pro",
            price: 295,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 13 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 13 Pro Max
        RepairPart(
            name: "Pantalla iPhone 13 Pro Max",
            price: 1300,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 13 Pro Max",
            price: 450,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 13 Pro Max",
            price: 370,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 13 Pro Max",
            price: 285,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 13 Pro Max",
            price: 450,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 13 Pro Max",
            price: 250,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 13 Pro Max",
            price: 270,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 13 Pro Max",
            price: 280,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 13 Pro Max",
            price: 330,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 13 Pro Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone SE (3a Gen)
        RepairPart(
            name: "Pantalla iPhone SE (3a Gen)",
            price: 750,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone SE (3a Gen)",
            price: 320,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone SE (3a Gen)",
            price: 240,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone SE (3a Gen)",
            price: 200,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone SE (3a Gen)",
            price: 310,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone SE (3a Gen)",
            price: 185,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone SE (3a Gen)",
            price: 200,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone SE (3a Gen)",
            price: 210,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone SE (3a Gen)",
            price: 240,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone SE (3a Gen)"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 14
        RepairPart(
            name: "Pantalla iPhone 14",
            price: 1300,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 14"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 14",
            price: 420,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 14"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 14",
            price: 350,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 14"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 14",
            price: 270,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 14"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 14",
            price: 410,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 14"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 14",
            price: 230,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 14"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 14",
            price: 255,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 14"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 14",
            price: 265,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 14"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 14",
            price: 310,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 14"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 14 Plus
        RepairPart(
            name: "Pantalla iPhone 14 Plus",
            price: 1450,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 14 Plus",
            price: 450,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 14 Plus",
            price: 370,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 14 Plus",
            price: 285,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 14 Plus",
            price: 430,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 14 Plus",
            price: 245,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 14 Plus",
            price: 268,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 14 Plus",
            price: 278,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 14 Plus",
            price: 325,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 14 Plus"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 14 Pro
        RepairPart(
            name: "Pantalla iPhone 14 Pro",
            price: 1550,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 14 Pro",
            price: 470,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 14 Pro",
            price: 390,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 14 Pro",
            price: 300,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 14 Pro",
            price: 450,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 14 Pro",
            price: 255,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 14 Pro",
            price: 278,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 14 Pro",
            price: 290,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 14 Pro",
            price: 340,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 14 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 14 Pro Max
        RepairPart(
            name: "Pantalla iPhone 14 Pro Max",
            price: 1800,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 14 Pro Max",
            price: 520,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 14 Pro Max",
            price: 430,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 14 Pro Max",
            price: 330,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 14 Pro Max",
            price: 490,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 14 Pro Max",
            price: 275,
            description: "Flex de puerto Lightning con microfono inferior integrado.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 14 Pro Max",
            price: 300,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 14 Pro Max",
            price: 312,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 14 Pro Max",
            price: 370,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 14 Pro Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 15
        RepairPart(
            name: "Pantalla iPhone 15",
            price: 1600,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 15"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 15",
            price: 460,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 15"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 15",
            price: 390,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 15"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 15",
            price: 300,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 15"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 15",
            price: 440,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 15"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 15",
            price: 255,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 15"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 15",
            price: 280,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 15"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 15",
            price: 290,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 15"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 15",
            price: 355,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 15"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 15 Plus
        RepairPart(
            name: "Pantalla iPhone 15 Plus",
            price: 1800,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 15 Plus",
            price: 490,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 15 Plus",
            price: 415,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 15 Plus",
            price: 315,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 15 Plus",
            price: 460,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 15 Plus",
            price: 268,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 15 Plus",
            price: 293,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 15 Plus",
            price: 305,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 15 Plus",
            price: 375,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 15 Plus"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 15 Pro
        RepairPart(
            name: "Pantalla iPhone 15 Pro",
            price: 1950,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 15 Pro",
            price: 510,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 15 Pro",
            price: 435,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 15 Pro",
            price: 330,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 15 Pro",
            price: 480,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 15 Pro",
            price: 280,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 15 Pro",
            price: 308,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 15 Pro",
            price: 320,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 15 Pro",
            price: 390,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 15 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 15 Pro Max
        RepairPart(
            name: "Pantalla iPhone 15 Pro Max",
            price: 2200,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 15 Pro Max",
            price: 560,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 15 Pro Max",
            price: 475,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 15 Pro Max",
            price: 360,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 15 Pro Max",
            price: 520,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 15 Pro Max",
            price: 305,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 15 Pro Max",
            price: 335,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 15 Pro Max",
            price: 348,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 15 Pro Max",
            price: 425,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 15 Pro Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 16
        RepairPart(
            name: "Pantalla iPhone 16",
            price: 1700,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 16"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 16",
            price: 470,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 16"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 16",
            price: 400,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 16"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 16",
            price: 308,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 16"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 16",
            price: 455,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 16"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 16",
            price: 260,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 16"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 16",
            price: 285,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 16"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 16",
            price: 295,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 16"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 16",
            price: 362,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 16"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 16 Plus
        RepairPart(
            name: "Pantalla iPhone 16 Plus",
            price: 1900,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 16 Plus",
            price: 500,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 16 Plus",
            price: 425,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 16 Plus",
            price: 325,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 16 Plus",
            price: 475,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 16 Plus",
            price: 272,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 16 Plus",
            price: 298,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 16 Plus",
            price: 308,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 16 Plus",
            price: 380,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 16 Plus"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 16 Pro
        RepairPart(
            name: "Pantalla iPhone 16 Pro",
            price: 2100,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 16 Pro",
            price: 540,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 16 Pro",
            price: 450,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 16 Pro",
            price: 345,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 16 Pro",
            price: 500,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 16 Pro",
            price: 288,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 16 Pro",
            price: 315,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 16 Pro",
            price: 328,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 16 Pro",
            price: 400,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 16 Pro Max
        RepairPart(
            name: "Pantalla iPhone 16 Pro Max",
            price: 2400,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 16 Pro Max",
            price: 590,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 16 Pro Max",
            price: 490,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 16 Pro Max",
            price: 375,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 16 Pro Max",
            price: 540,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 16 Pro Max",
            price: 312,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 16 Pro Max",
            price: 342,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 16 Pro Max",
            price: 355,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 16 Pro Max",
            price: 435,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 16 Pro Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 16e
        RepairPart(
            name: "Pantalla iPhone 16e",
            price: 1350,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 16e",
            price: 430,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 16e",
            price: 360,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 16e",
            price: 278,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 16e",
            price: 420,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 16e",
            price: 238,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 16e",
            price: 260,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 16e",
            price: 270,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 16e",
            price: 318,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 16e"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 17e
        RepairPart(
            name: "Pantalla iPhone 17e",
            price: 1400,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 17e",
            price: 440,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 17e",
            price: 368,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 17e",
            price: 282,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 17e",
            price: 428,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 17e",
            price: 242,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 17e",
            price: 264,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 17e",
            price: 274,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 17e",
            price: 322,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 17e"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 17
        RepairPart(
            name: "Pantalla iPhone 17",
            price: 1800,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 17"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 17",
            price: 490,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 17"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 17",
            price: 415,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 17"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 17",
            price: 318,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 17"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 17",
            price: 468,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 17"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 17",
            price: 265,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 17"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 17",
            price: 290,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 17"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 17",
            price: 300,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 17"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 17",
            price: 368,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 17"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone Air
        RepairPart(
            name: "Pantalla iPhone Air",
            price: 2000,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone Air"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone Air",
            price: 520,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone Air"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone Air",
            price: 440,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone Air"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone Air",
            price: 335,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone Air"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone Air",
            price: 485,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone Air"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone Air",
            price: 275,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone Air"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone Air",
            price: 302,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone Air"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone Air",
            price: 315,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone Air"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone Air",
            price: 382,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone Air"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 17 Pro
        RepairPart(
            name: "Pantalla iPhone 17 Pro",
            price: 2200,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 17 Pro",
            price: 550,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 17 Pro",
            price: 460,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 17 Pro",
            price: 348,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 17 Pro",
            price: 505,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 17 Pro",
            price: 288,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 17 Pro",
            price: 316,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 17 Pro",
            price: 330,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 17 Pro",
            price: 398,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 17 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: - iPhone 17 Pro Max
        RepairPart(
            name: "Pantalla iPhone 17 Pro Max",
            price: 2500,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Bateria iPhone 17 Pro Max",
            price: 600,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de salud incluida.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Trasera iPhone 17 Pro Max",
            price: 500,
            description: "Modulo de camara trasera original con estabilizacion optica.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "40-50 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Camara Frontal iPhone 17 Pro Max",
            price: 378,
            description: "Camara frontal TrueDepth con soporte para Face ID.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Modulo Face ID iPhone 17 Pro Max",
            price: 545,
            description: "Modulo TrueDepth completo para reconocimiento facial de alta precision.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Puerto de Carga iPhone 17 Pro Max",
            price: 310,
            description: "Flex de puerto USB-C con microfono inferior integrado.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Altavoces iPhone 17 Pro Max",
            price: 340,
            description: "Modulo de altavoz auricular y altavoz principal con resistencia al agua.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Taptic Engine iPhone 17 Pro Max",
            price: 355,
            description: "Motor de vibracion haptica original para respuesta tactil precisa.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "30-40 min",
            stock: true,
            imageName: "iphone1"
        ),
        RepairPart(
            name: "Tapa Trasera iPhone 17 Pro Max",
            price: 432,
            description: "Tapa trasera de vidrio con sellado original y soporte MagSafe.",
            compatibleModels: ["iPhone 17 Pro Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "iphone1"
        ),

        // MARK: ══ iPad ══

        // MARK: - iPad 7a Gen
        RepairPart(
            name: "Pantalla iPad 7a Gen",
            price: 700,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad 7a Gen",
            price: 280,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad 7a Gen",
            price: 210,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad 7a Gen",
            price: 180,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad 7a Gen",
            price: 170,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad 7a Gen",
            price: 230,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad 7a Gen",
            price: 160,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad 7a Gen",
            price: 160,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad 7a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad 8a Gen
        RepairPart(
            name: "Pantalla iPad 8a Gen",
            price: 750,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad 8a Gen",
            price: 295,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad 8a Gen",
            price: 220,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad 8a Gen",
            price: 185,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad 8a Gen",
            price: 175,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad 8a Gen",
            price: 245,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad 8a Gen",
            price: 168,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad 8a Gen",
            price: 160,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad 8a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad 9a Gen
        RepairPart(
            name: "Pantalla iPad 9a Gen",
            price: 800,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad 9a Gen",
            price: 310,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad 9a Gen",
            price: 232,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad 9a Gen",
            price: 192,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad 9a Gen",
            price: 182,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad 9a Gen",
            price: 258,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad 9a Gen",
            price: 175,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad 9a Gen",
            price: 160,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad 9a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad 10a Gen
        RepairPart(
            name: "Pantalla iPad 10a Gen",
            price: 900,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad 10a Gen",
            price: 345,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad 10a Gen",
            price: 258,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad 10a Gen",
            price: 208,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad 10a Gen",
            price: 198,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad 10a Gen",
            price: 285,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad 10a Gen",
            price: 190,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad 10a Gen",
            price: 160,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad 10a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad mini 5a Gen
        RepairPart(
            name: "Pantalla iPad mini 5a Gen",
            price: 850,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad mini 5a Gen",
            price: 320,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad mini 5a Gen",
            price: 240,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad mini 5a Gen",
            price: 198,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad mini 5a Gen",
            price: 188,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad mini 5a Gen",
            price: 268,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad mini 5a Gen",
            price: 178,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad mini 5a Gen",
            price: 160,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad mini 5a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad mini 6
        RepairPart(
            name: "Pantalla iPad mini 6",
            price: 950,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad mini 6",
            price: 360,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad mini 6",
            price: 268,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad mini 6",
            price: 218,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad mini 6",
            price: 208,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad mini 6",
            price: 298,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad mini 6",
            price: 198,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad mini 6",
            price: 168,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad mini 6"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad mini 7
        RepairPart(
            name: "Pantalla iPad mini 7",
            price: 1020,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad mini 7",
            price: 385,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad mini 7",
            price: 288,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad mini 7",
            price: 232,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad mini 7",
            price: 222,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad mini 7",
            price: 318,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad mini 7",
            price: 210,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad mini 7",
            price: 180,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad mini 7"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Air 3a Gen
        RepairPart(
            name: "Pantalla iPad Air 3a Gen",
            price: 880,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Air 3a Gen",
            price: 335,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Air 3a Gen",
            price: 250,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Air 3a Gen",
            price: 205,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Air 3a Gen",
            price: 195,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Air 3a Gen",
            price: 272,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Air 3a Gen",
            price: 182,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad Air 3a Gen",
            price: 160,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Air 3a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Air 4a Gen
        RepairPart(
            name: "Pantalla iPad Air 4a Gen",
            price: 980,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Air 4a Gen",
            price: 368,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Air 4a Gen",
            price: 275,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Air 4a Gen",
            price: 222,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Air 4a Gen",
            price: 212,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Air 4a Gen",
            price: 302,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Air 4a Gen",
            price: 202,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad Air 4a Gen",
            price: 172,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Air 4a Gen"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Air 5a Gen (M1)
        RepairPart(
            name: "Pantalla iPad Air 5a Gen (M1)",
            price: 1100,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Air 5a Gen (M1)",
            price: 405,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Air 5a Gen (M1)",
            price: 302,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Air 5a Gen (M1)",
            price: 245,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Air 5a Gen (M1)",
            price: 235,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Air 5a Gen (M1)",
            price: 335,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Air 5a Gen (M1)",
            price: 222,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad Air 5a Gen (M1)",
            price: 192,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Air 5a Gen (M1)"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Air 11 M2
        RepairPart(
            name: "Pantalla iPad Air 11 M2",
            price: 1250,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Air 11 M2",
            price: 445,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Air 11 M2",
            price: 332,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Air 11 M2",
            price: 268,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Air 11 M2",
            price: 258,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Air 11 M2",
            price: 368,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Air 11 M2",
            price: 240,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad Air 11 M2",
            price: 210,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Air 11 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Air 13 M2
        RepairPart(
            name: "Pantalla iPad Air 13 M2",
            price: 1350,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Air 13 M2",
            price: 475,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Air 13 M2",
            price: 355,
            description: "Modulo de camara trasera original.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Air 13 M2",
            price: 285,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Air 13 M2",
            price: 272,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Air 13 M2",
            price: 392,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Air 13 M2",
            price: 255,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Smart Keyboard iPad Air 13 M2",
            price: 225,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Air 13 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Pro 12.9 M1
        RepairPart(
            name: "Pantalla iPad Pro 12.9 M1",
            price: 1500,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Pro 12.9 M1",
            price: 520,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Pro 12.9 M1",
            price: 388,
            description: "Modulo de camara trasera original con escaner LiDAR.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Pro 12.9 M1",
            price: 315,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Pro 12.9 M1",
            price: 300,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Pro 12.9 M1",
            price: 425,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Pro 12.9 M1",
            price: 278,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Magic Keyboard iPad Pro 12.9 M1",
            price: 248,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Pro 12.9 M1"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Pro 11 M2
        RepairPart(
            name: "Pantalla iPad Pro 11 M2",
            price: 1600,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Pro 11 M2",
            price: 550,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Pro 11 M2",
            price: 410,
            description: "Modulo de camara trasera original con escaner LiDAR.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Pro 11 M2",
            price: 332,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Pro 11 M2",
            price: 318,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Pro 11 M2",
            price: 448,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Pro 11 M2",
            price: 292,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Magic Keyboard iPad Pro 11 M2",
            price: 262,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Pro 11 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Pro 12.9 M2
        RepairPart(
            name: "Pantalla iPad Pro 12.9 M2",
            price: 1700,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Pro 12.9 M2",
            price: 585,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Pro 12.9 M2",
            price: 435,
            description: "Modulo de camara trasera original con escaner LiDAR.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Pro 12.9 M2",
            price: 352,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Pro 12.9 M2",
            price: 338,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Pro 12.9 M2",
            price: 475,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Pro 12.9 M2",
            price: 308,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Magic Keyboard iPad Pro 12.9 M2",
            price: 278,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Pro 12.9 M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Pro 11 M4
        RepairPart(
            name: "Pantalla iPad Pro 11 M4",
            price: 1800,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Pro 11 M4",
            price: 620,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Pro 11 M4",
            price: 460,
            description: "Modulo de camara trasera original con escaner LiDAR.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Pro 11 M4",
            price: 372,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Pro 11 M4",
            price: 358,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Pro 11 M4",
            price: 502,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Pro 11 M4",
            price: 325,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Magic Keyboard iPad Pro 11 M4",
            price: 295,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Pro 11 M4"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: - iPad Pro 13 M4
        RepairPart(
            name: "Pantalla iPad Pro 13 M4",
            price: 2100,
            description: "Pantalla Liquid Retina original con digitalizador tacil.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Bateria iPad Pro 13 M4",
            price: 700,
            description: "Bateria de reemplazo con capacidad 100% y calibracion incluida.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Trasera iPad Pro 13 M4",
            price: 520,
            description: "Modulo de camara trasera original con escaner LiDAR.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Camara Frontal iPad Pro 13 M4",
            price: 420,
            description: "Camara frontal original con soporte para video FaceTime.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Puerto USB-C iPad Pro 13 M4",
            price: 402,
            description: "Puerto USB-C original para carga y transferencia de datos.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "35-50 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Altavoces iPad Pro 13 M4",
            price: 568,
            description: "Conjunto de altavoces estereo originales.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Tapa Trasera iPad Pro 13 M4",
            price: 368,
            description: "Tapa trasera de aluminio con acabado original.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "ipad1"
        ),
        RepairPart(
            name: "Conector Magic Keyboard iPad Pro 13 M4",
            price: 338,
            description: "Conector lateral original para accesorios de teclado Apple.",
            compatibleModels: ["iPad Pro 13 M4"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "ipad1"
        ),

        // MARK: ══ MacBook Air ══

        // MARK: - MacBook Air 13 M2
        RepairPart(
            name: "Pantalla MacBook Air 13 M2",
            price: 2200,
            description: "Pantalla Liquid Retina original con retroiluminacion True Tone.",
            compatibleModels: ["MacBook Air 13 M2"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Air 13 M2",
            price: 800,
            description: "Bateria de reemplazo original con calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Air 13 M2"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Air 13 M2",
            price: 650,
            description: "Teclado Magic Keyboard retroiluminado con soporte Touch ID.",
            compatibleModels: ["MacBook Air 13 M2"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Air 13 M2",
            price: 550,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Air 13 M2"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Air 13 M2",
            price: 400,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Air 13 M2"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Air 13 M2",
            price: 900,
            description: "Ensamblaje de tapa con pantalla Retina y camara FaceTime integrada.",
            compatibleModels: ["MacBook Air 13 M2"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Air 13 M3
        RepairPart(
            name: "Pantalla MacBook Air 13 M3",
            price: 2450,
            description: "Pantalla Liquid Retina original con retroiluminacion True Tone.",
            compatibleModels: ["MacBook Air 13 M3"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Air 13 M3",
            price: 860,
            description: "Bateria de reemplazo original con calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Air 13 M3"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Air 13 M3",
            price: 695,
            description: "Teclado Magic Keyboard retroiluminado con soporte Touch ID.",
            compatibleModels: ["MacBook Air 13 M3"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Air 13 M3",
            price: 580,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Air 13 M3"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Air 13 M3",
            price: 425,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Air 13 M3"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Air 13 M3",
            price: 980,
            description: "Ensamblaje de tapa con pantalla Retina y camara FaceTime integrada.",
            compatibleModels: ["MacBook Air 13 M3"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Air 13 M4
        RepairPart(
            name: "Pantalla MacBook Air 13 M4",
            price: 2700,
            description: "Pantalla Liquid Retina original con retroiluminacion True Tone.",
            compatibleModels: ["MacBook Air 13 M4"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Air 13 M4",
            price: 920,
            description: "Bateria de reemplazo original con calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Air 13 M4"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Air 13 M4",
            price: 740,
            description: "Teclado Magic Keyboard retroiluminado con soporte Touch ID.",
            compatibleModels: ["MacBook Air 13 M4"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Air 13 M4",
            price: 615,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Air 13 M4"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Air 13 M4",
            price: 450,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Air 13 M4"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Air 13 M4",
            price: 1080,
            description: "Ensamblaje de tapa con pantalla Retina y camara FaceTime integrada.",
            compatibleModels: ["MacBook Air 13 M4"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Air 15 M3
        RepairPart(
            name: "Pantalla MacBook Air 15 M3",
            price: 2600,
            description: "Pantalla Liquid Retina original con retroiluminacion True Tone.",
            compatibleModels: ["MacBook Air 15 M3"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Air 15 M3",
            price: 890,
            description: "Bateria de reemplazo original con calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Air 15 M3"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Air 15 M3",
            price: 720,
            description: "Teclado Magic Keyboard retroiluminado con soporte Touch ID.",
            compatibleModels: ["MacBook Air 15 M3"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Air 15 M3",
            price: 600,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Air 15 M3"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Air 15 M3",
            price: 440,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Air 15 M3"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Air 15 M3",
            price: 1020,
            description: "Ensamblaje de tapa con pantalla Retina y camara FaceTime integrada.",
            compatibleModels: ["MacBook Air 15 M3"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Air 15 M4
        RepairPart(
            name: "Pantalla MacBook Air 15 M4",
            price: 2900,
            description: "Pantalla Liquid Retina original con retroiluminacion True Tone.",
            compatibleModels: ["MacBook Air 15 M4"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Air 15 M4",
            price: 950,
            description: "Bateria de reemplazo original con calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Air 15 M4"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Air 15 M4",
            price: 760,
            description: "Teclado Magic Keyboard retroiluminado con soporte Touch ID.",
            compatibleModels: ["MacBook Air 15 M4"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Air 15 M4",
            price: 635,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Air 15 M4"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Air 15 M4",
            price: 465,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Air 15 M4"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Air 15 M4",
            price: 1120,
            description: "Ensamblaje de tapa con pantalla Retina y camara FaceTime integrada.",
            compatibleModels: ["MacBook Air 15 M4"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: ══ MacBook Pro ══

        // MARK: - MacBook Pro 14 M1 Pro
        RepairPart(
            name: "Pantalla MacBook Pro 14 M1 Pro",
            price: 3200,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 14 M1 Pro"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 14 M1 Pro",
            price: 950,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 14 M1 Pro"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 14 M1 Pro",
            price: 780,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 14 M1 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 14 M1 Pro",
            price: 640,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 14 M1 Pro"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 14 M1 Pro",
            price: 480,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 14 M1 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 14 M1 Pro",
            price: 1350,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 14 M1 Pro"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 16 M1 Max
        RepairPart(
            name: "Pantalla MacBook Pro 16 M1 Max",
            price: 4200,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 16 M1 Max"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 16 M1 Max",
            price: 1100,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 16 M1 Max"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 16 M1 Max",
            price: 900,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 16 M1 Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 16 M1 Max",
            price: 740,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 16 M1 Max"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 16 M1 Max",
            price: 560,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 16 M1 Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 16 M1 Max",
            price: 1700,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 16 M1 Max"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 14 M3 Pro
        RepairPart(
            name: "Pantalla MacBook Pro 14 M3 Pro",
            price: 3450,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 14 M3 Pro"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 14 M3 Pro",
            price: 1000,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 14 M3 Pro"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 14 M3 Pro",
            price: 820,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 14 M3 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 14 M3 Pro",
            price: 678,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 14 M3 Pro"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 14 M3 Pro",
            price: 510,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 14 M3 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 14 M3 Pro",
            price: 1420,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 14 M3 Pro"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 16 M3 Max
        RepairPart(
            name: "Pantalla MacBook Pro 16 M3 Max",
            price: 4600,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 16 M3 Max"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 16 M3 Max",
            price: 1180,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 16 M3 Max"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 16 M3 Max",
            price: 950,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 16 M3 Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 16 M3 Max",
            price: 780,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 16 M3 Max"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 16 M3 Max",
            price: 590,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 16 M3 Max"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 16 M3 Max",
            price: 1820,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 16 M3 Max"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 14 M4 Pro
        RepairPart(
            name: "Pantalla MacBook Pro 14 M4 Pro",
            price: 3700,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 14 M4 Pro"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 14 M4 Pro",
            price: 1050,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 14 M4 Pro"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 14 M4 Pro",
            price: 858,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 14 M4 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 14 M4 Pro",
            price: 710,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 14 M4 Pro"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 14 M4 Pro",
            price: 535,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 14 M4 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 14 M4 Pro",
            price: 1490,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 14 M4 Pro"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 16 M4 Pro
        RepairPart(
            name: "Pantalla MacBook Pro 16 M4 Pro",
            price: 5000,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 16 M4 Pro"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 16 M4 Pro",
            price: 1250,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 16 M4 Pro"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 16 M4 Pro",
            price: 998,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 16 M4 Pro"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 16 M4 Pro",
            price: 820,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 16 M4 Pro"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 16 M4 Pro",
            price: 618,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 16 M4 Pro"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 16 M4 Pro",
            price: 1920,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 16 M4 Pro"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 14 M5
        RepairPart(
            name: "Pantalla MacBook Pro 14 M5",
            price: 4000,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 14 M5"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 14 M5",
            price: 1120,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 14 M5"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 14 M5",
            price: 910,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 14 M5"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 14 M5",
            price: 750,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 14 M5"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 14 M5",
            price: 565,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 14 M5"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 14 M5",
            price: 1570,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 14 M5"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - MacBook Pro 16 M5
        RepairPart(
            name: "Pantalla MacBook Pro 16 M5",
            price: 5400,
            description: "Pantalla Liquid Retina XDR con ProMotion 120Hz y True Tone.",
            compatibleModels: ["MacBook Pro 16 M5"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Bateria MacBook Pro 16 M5",
            price: 1320,
            description: "Bateria de reemplazo con capacidad 100% y calibracion de ciclos incluida.",
            compatibleModels: ["MacBook Pro 16 M5"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado MacBook Pro 16 M5",
            price: 1060,
            description: "Teclado Magic Keyboard retroiluminado con Touch ID.",
            compatibleModels: ["MacBook Pro 16 M5"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Trackpad MacBook Pro 16 M5",
            price: 868,
            description: "Trackpad Force Touch original con retroalimentacion haptica.",
            compatibleModels: ["MacBook Pro 16 M5"],
            repairTime: "45-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto MagSafe 3 MacBook Pro 16 M5",
            price: 652,
            description: "Conector MagSafe 3 original y flex de carga.",
            compatibleModels: ["MacBook Pro 16 M5"],
            repairTime: "50-70 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Tapa Superior MacBook Pro 16 M5",
            price: 2050,
            description: "Ensamblaje de tapa con pantalla XDR y camara 12MP integrada.",
            compatibleModels: ["MacBook Pro 16 M5"],
            repairTime: "90-130 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: ══ iMac ══
        // MARK: - iMac 24 M3
        RepairPart(
            name: "Pantalla iMac 24 M3",
            price: 4500,
            description: "Pantalla Retina 4.5K de 24 pulgadas original con True Tone.",
            compatibleModels: ["iMac 24 M3"],
            repairTime: "120-150 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Fuente de Poder iMac 24 M3",
            price: 1100,
            description: "Fuente de alimentacion interna original.",
            compatibleModels: ["iMac 24 M3"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Teclado Magic iMac 24 M3",
            price: 750,
            description: "Magic Keyboard con Touch ID y lector de huella integrado.",
            compatibleModels: ["iMac 24 M3"],
            repairTime: "15-20 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Magic Trackpad iMac 24 M3",
            price: 620,
            description: "Magic Trackpad con Force Touch y retroalimentacion haptica.",
            compatibleModels: ["iMac 24 M3"],
            repairTime: "15-20 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt iMac 24 M3",
            price: 480,
            description: "Placa de puertos Thunderbolt/USB-C y USB-A lateral.",
            compatibleModels: ["iMac 24 M3"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: ══ Mac mini ══

        // MARK: - Mac mini M1
        RepairPart(
            name: "Fuente de Poder Mac mini M1",
            price: 800,
            description: "Fuente de alimentacion interna original.",
            compatibleModels: ["Mac mini M1"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Placa Logica Mac mini M1",
            price: 580,
            description: "Placa logica original con chip Apple Silicon integrado.",
            compatibleModels: ["Mac mini M1"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt Mac mini M1",
            price: 420,
            description: "Placa de puertos trasera con Thunderbolt, USB-A y HDMI.",
            compatibleModels: ["Mac mini M1"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - Mac mini M2
        RepairPart(
            name: "Fuente de Poder Mac mini M2",
            price: 880,
            description: "Fuente de alimentacion interna original.",
            compatibleModels: ["Mac mini M2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Placa Logica Mac mini M2",
            price: 620,
            description: "Placa logica original con chip Apple Silicon integrado.",
            compatibleModels: ["Mac mini M2"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt Mac mini M2",
            price: 450,
            description: "Placa de puertos trasera con Thunderbolt, USB-A y HDMI.",
            compatibleModels: ["Mac mini M2"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - Mac mini M4
        RepairPart(
            name: "Fuente de Poder Mac mini M4",
            price: 960,
            description: "Fuente de alimentacion interna original.",
            compatibleModels: ["Mac mini M4"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Placa Logica Mac mini M4",
            price: 665,
            description: "Placa logica original con chip Apple Silicon integrado.",
            compatibleModels: ["Mac mini M4"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt Mac mini M4",
            price: 480,
            description: "Placa de puertos trasera con Thunderbolt, USB-A y HDMI.",
            compatibleModels: ["Mac mini M4"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - Mac mini M4 Pro
        RepairPart(
            name: "Fuente de Poder Mac mini M4 Pro",
            price: 1050,
            description: "Fuente de alimentacion interna original.",
            compatibleModels: ["Mac mini M4 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Placa Logica Mac mini M4 Pro",
            price: 720,
            description: "Placa logica original con chip Apple Silicon integrado.",
            compatibleModels: ["Mac mini M4 Pro"],
            repairTime: "90-120 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt Mac mini M4 Pro",
            price: 520,
            description: "Placa de puertos trasera con Thunderbolt, USB-A y HDMI.",
            compatibleModels: ["Mac mini M4 Pro"],
            repairTime: "60-80 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: ══ Mac Studio y Mac Pro ══

        // MARK: - Mac Studio M4 Max
        RepairPart(
            name: "Fuente de Poder Mac Studio M4 Max",
            price: 1800,
            description: "Fuente de alimentacion modular original.",
            compatibleModels: ["Mac Studio M4 Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Placa Logica Mac Studio M4 Max",
            price: 2200,
            description: "Placa logica original con chip Apple Silicon de alto rendimiento.",
            compatibleModels: ["Mac Studio M4 Max"],
            repairTime: "120-180 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt Mac Studio M4 Max",
            price: 900,
            description: "Placa de puertos Thunderbolt 5 y USB-A originales.",
            compatibleModels: ["Mac Studio M4 Max"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: - Mac Pro M4 Ultra
        RepairPart(
            name: "Fuente de Poder Mac Pro M4 Ultra",
            price: 3500,
            description: "Fuente de alimentacion modular original.",
            compatibleModels: ["Mac Pro M4 Ultra"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Placa Logica Mac Pro M4 Ultra",
            price: 5000,
            description: "Placa logica original con chip Apple Silicon de alto rendimiento.",
            compatibleModels: ["Mac Pro M4 Ultra"],
            repairTime: "120-180 min",
            stock: true,
            imageName: "mac1"
        ),
        RepairPart(
            name: "Puerto Thunderbolt Mac Pro M4 Ultra",
            price: 1400,
            description: "Placa de puertos Thunderbolt 5 y USB-A originales.",
            compatibleModels: ["Mac Pro M4 Ultra"],
            repairTime: "60-90 min",
            stock: true,
            imageName: "mac1"
        ),

        // MARK: ══ Apple Watch ══

        // MARK: - Apple Watch Series 6
        RepairPart(
            name: "Pantalla Apple Watch Series 6",
            price: 600,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Series 6"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Series 6",
            price: 280,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Series 6"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Series 6",
            price: 300,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Series 6"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Series 6",
            price: 320,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Series 6"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch SE 1
        RepairPart(
            name: "Pantalla Apple Watch SE 1",
            price: 520,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch SE 1"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch SE 1",
            price: 250,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch SE 1"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch SE 1",
            price: 268,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch SE 1"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch SE 1",
            price: 288,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch SE 1"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Series 7
        RepairPart(
            name: "Pantalla Apple Watch Series 7",
            price: 640,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Series 7"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Series 7",
            price: 295,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Series 7"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Series 7",
            price: 315,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Series 7"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Series 7",
            price: 335,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Series 7"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Series 8
        RepairPart(
            name: "Pantalla Apple Watch Series 8",
            price: 680,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Series 8"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Series 8",
            price: 315,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Series 8"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Series 8",
            price: 335,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Series 8"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Series 8",
            price: 355,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Series 8"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch SE 2
        RepairPart(
            name: "Pantalla Apple Watch SE 2",
            price: 560,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch SE 2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch SE 2",
            price: 262,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch SE 2"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch SE 2",
            price: 280,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch SE 2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch SE 2",
            price: 300,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch SE 2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Nike Series 8
        RepairPart(
            name: "Pantalla Apple Watch Nike Series 8",
            price: 695,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Nike Series 8"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Nike Series 8",
            price: 320,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Nike Series 8"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Nike Series 8",
            price: 340,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Nike Series 8"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Nike Series 8",
            price: 360,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Nike Series 8"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Hermes Series 8
        RepairPart(
            name: "Pantalla Apple Watch Hermes Series 8",
            price: 730,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Hermes Series 8"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Hermes Series 8",
            price: 340,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Hermes Series 8"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Hermes Series 8",
            price: 360,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Hermes Series 8"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Hermes Series 8",
            price: 380,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Hermes Series 8"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Series 9
        RepairPart(
            name: "Pantalla Apple Watch Series 9",
            price: 720,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Series 9"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Series 9",
            price: 332,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Series 9"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Series 9",
            price: 352,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Series 9"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Series 9",
            price: 372,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Series 9"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Nike Series 9
        RepairPart(
            name: "Pantalla Apple Watch Nike Series 9",
            price: 738,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Nike Series 9"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Nike Series 9",
            price: 338,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Nike Series 9"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Nike Series 9",
            price: 358,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Nike Series 9"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Nike Series 9",
            price: 378,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Nike Series 9"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Hermes Series 9
        RepairPart(
            name: "Pantalla Apple Watch Hermes Series 9",
            price: 780,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Hermes Series 9"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Hermes Series 9",
            price: 358,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Hermes Series 9"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Hermes Series 9",
            price: 378,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Hermes Series 9"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Hermes Series 9",
            price: 398,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Hermes Series 9"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Ultra 2
        RepairPart(
            name: "Pantalla Apple Watch Ultra 2",
            price: 1100,
            description: "Pantalla LTPO OLED original con cristal de zafiro y Always-On.",
            compatibleModels: ["Apple Watch Ultra 2"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Ultra 2",
            price: 520,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Ultra 2"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Ultra 2",
            price: 560,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Ultra 2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Ultra 2",
            price: 580,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Ultra 2"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Series 10
        RepairPart(
            name: "Pantalla Apple Watch Series 10",
            price: 760,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Series 10"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Series 10",
            price: 348,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Series 10"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Series 10",
            price: 368,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Series 10"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Series 10",
            price: 388,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Series 10"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch SE 3
        RepairPart(
            name: "Pantalla Apple Watch SE 3",
            price: 600,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch SE 3"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch SE 3",
            price: 278,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch SE 3"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch SE 3",
            price: 298,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch SE 3"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch SE 3",
            price: 318,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch SE 3"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Series 11
        RepairPart(
            name: "Pantalla Apple Watch Series 11",
            price: 800,
            description: "Pantalla LTPO OLED original con cristal Ion-X y Always-On.",
            compatibleModels: ["Apple Watch Series 11"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Series 11",
            price: 365,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Series 11"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Series 11",
            price: 385,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Series 11"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Series 11",
            price: 405,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Series 11"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: - Apple Watch Ultra 3
        RepairPart(
            name: "Pantalla Apple Watch Ultra 3",
            price: 1200,
            description: "Pantalla LTPO OLED original con cristal de zafiro y Always-On.",
            compatibleModels: ["Apple Watch Ultra 3"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Bateria Apple Watch Ultra 3",
            price: 560,
            description: "Bateria de reemplazo original con calibracion de salud incluida.",
            compatibleModels: ["Apple Watch Ultra 3"],
            repairTime: "30-45 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Corona Digital Apple Watch Ultra 3",
            price: 600,
            description: "Corona Digital original con retroalimentacion haptica.",
            compatibleModels: ["Apple Watch Ultra 3"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),
        RepairPart(
            name: "Sensor Trasero Apple Watch Ultra 3",
            price: 620,
            description: "Sensor de frecuencia cardiaca, SpO2 y temperatura corporal original.",
            compatibleModels: ["Apple Watch Ultra 3"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "watch1"
        ),

        // MARK: ══ AirPods ══

        // MARK: - AirPods 2a Gen
        RepairPart(
            name: "Auricular Izquierdo AirPods 2a Gen",
            price: 250,
            description: "Auricular izquierdo original.",
            compatibleModels: ["AirPods 2a Gen"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods 2a Gen",
            price: 250,
            description: "Auricular derecho original.",
            compatibleModels: ["AirPods 2a Gen"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods 2a Gen",
            price: 180,
            description: "Case de carga original.",
            compatibleModels: ["AirPods 2a Gen"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods 2a Gen",
            price: 80,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods 2a Gen"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods 3a Gen
        RepairPart(
            name: "Auricular Izquierdo AirPods 3a Gen",
            price: 280,
            description: "Auricular izquierdo original.",
            compatibleModels: ["AirPods 3a Gen"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods 3a Gen",
            price: 280,
            description: "Auricular derecho original.",
            compatibleModels: ["AirPods 3a Gen"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods 3a Gen",
            price: 200,
            description: "Case de carga original.",
            compatibleModels: ["AirPods 3a Gen"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods 3a Gen",
            price: 90,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods 3a Gen"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods Pro 1a Gen
        RepairPart(
            name: "Auricular Izquierdo AirPods Pro 1a Gen",
            price: 320,
            description: "Auricular izquierdo original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 1a Gen"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods Pro 1a Gen",
            price: 320,
            description: "Auricular derecho original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 1a Gen"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods Pro 1a Gen",
            price: 230,
            description: "Case de carga original.",
            compatibleModels: ["AirPods Pro 1a Gen"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods Pro 1a Gen",
            price: 100,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods Pro 1a Gen"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods Pro 2 Lightning
        RepairPart(
            name: "Auricular Izquierdo AirPods Pro 2 Lightning",
            price: 370,
            description: "Auricular izquierdo original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 2 Lightning"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods Pro 2 Lightning",
            price: 370,
            description: "Auricular derecho original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 2 Lightning"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods Pro 2 Lightning",
            price: 268,
            description: "Case de carga original.",
            compatibleModels: ["AirPods Pro 2 Lightning"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods Pro 2 Lightning",
            price: 115,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods Pro 2 Lightning"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods Pro 2 USB-C
        RepairPart(
            name: "Auricular Izquierdo AirPods Pro 2 USB-C",
            price: 360,
            description: "Auricular izquierdo original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 2 USB-C"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods Pro 2 USB-C",
            price: 360,
            description: "Auricular derecho original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 2 USB-C"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods Pro 2 USB-C",
            price: 260,
            description: "Case de carga original.",
            compatibleModels: ["AirPods Pro 2 USB-C"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods Pro 2 USB-C",
            price: 112,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods Pro 2 USB-C"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods Pro 3
        RepairPart(
            name: "Auricular Izquierdo AirPods Pro 3",
            price: 390,
            description: "Auricular izquierdo original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 3"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods Pro 3",
            price: 390,
            description: "Auricular derecho original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods Pro 3"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods Pro 3",
            price: 280,
            description: "Case de carga original.",
            compatibleModels: ["AirPods Pro 3"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods Pro 3",
            price: 120,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods Pro 3"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods 4
        RepairPart(
            name: "Auricular Izquierdo AirPods 4",
            price: 290,
            description: "Auricular izquierdo original.",
            compatibleModels: ["AirPods 4"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods 4",
            price: 290,
            description: "Auricular derecho original.",
            compatibleModels: ["AirPods 4"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods 4",
            price: 210,
            description: "Case de carga original.",
            compatibleModels: ["AirPods 4"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods 4",
            price: 95,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods 4"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods 4 con ANC
        RepairPart(
            name: "Auricular Izquierdo AirPods 4 con ANC",
            price: 330,
            description: "Auricular izquierdo original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods 4 con ANC"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods 4 con ANC",
            price: 330,
            description: "Auricular derecho original con cancelacion activa de ruido.",
            compatibleModels: ["AirPods 4 con ANC"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Case de Carga AirPods 4 con ANC",
            price: 238,
            description: "Case de carga original.",
            compatibleModels: ["AirPods 4 con ANC"],
            repairTime: "15-25 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas de Silicona AirPods 4 con ANC",
            price: 102,
            description: "Set de almohadillas de silicona originales (S/M/L).",
            compatibleModels: ["AirPods 4 con ANC"],
            repairTime: "5-10 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods Max (Lightning)
        RepairPart(
            name: "Auricular Izquierdo AirPods Max (Lightning)",
            price: 1150,
            description: "Controlador de audio izquierdo con driver de 40mm.",
            compatibleModels: ["AirPods Max (Lightning)"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods Max (Lightning)",
            price: 1150,
            description: "Controlador de audio derecho con driver de 40mm.",
            compatibleModels: ["AirPods Max (Lightning)"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Diadema AirPods Max (Lightning)",
            price: 600,
            description: "Diadema de malla trenzada original con soporte de aluminio.",
            compatibleModels: ["AirPods Max (Lightning)"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas AirPods Max (Lightning)",
            price: 420,
            description: "Almohadillas de espuma con memoria originales, par completo.",
            compatibleModels: ["AirPods Max (Lightning)"],
            repairTime: "10-15 min",
            stock: true,
            imageName: "airpods1"
        ),

        // MARK: - AirPods Max USB-C
        RepairPart(
            name: "Auricular Izquierdo AirPods Max USB-C",
            price: 1250,
            description: "Controlador de audio izquierdo con driver de 40mm.",
            compatibleModels: ["AirPods Max USB-C"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Auricular Derecho AirPods Max USB-C",
            price: 1250,
            description: "Controlador de audio derecho con driver de 40mm.",
            compatibleModels: ["AirPods Max USB-C"],
            repairTime: "40-55 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Diadema AirPods Max USB-C",
            price: 650,
            description: "Diadema de malla trenzada original con soporte de aluminio.",
            compatibleModels: ["AirPods Max USB-C"],
            repairTime: "20-30 min",
            stock: true,
            imageName: "airpods1"
        ),
        RepairPart(
            name: "Almohadillas AirPods Max USB-C",
            price: 450,
            description: "Almohadillas de espuma con memoria originales, par completo.",
            compatibleModels: ["AirPods Max USB-C"],
            repairTime: "10-15 min",
            stock: true,
            imageName: "airpods1"
        ),

    ]

    // MARK: - Categorias
    static let categories = ["iPhone", "iPad", "Mac", "Apple Watch", "AirPods"]

    // MARK: - Modelos por categoria
    static let modelsByCategory: [String: [String]] = [
        "iPhone":      [
            "iPhone 12",
            "iPhone 12 Pro",
            "iPhone 12 Pro Max",
            "iPhone 13 Mini",
            "iPhone 13",
            "iPhone 13 Pro",
            "iPhone 13 Pro Max",
            "iPhone SE (3a Gen)",
            "iPhone 14",
            "iPhone 14 Plus",
            "iPhone 14 Pro",
            "iPhone 14 Pro Max",
            "iPhone 15",
            "iPhone 15 Plus",
            "iPhone 15 Pro",
            "iPhone 15 Pro Max",
            "iPhone 16",
            "iPhone 16 Plus",
            "iPhone 16 Pro",
            "iPhone 16 Pro Max",
            "iPhone 16e",
            "iPhone 17e",
            "iPhone 17",
            "iPhone Air",
            "iPhone 17 Pro",
            "iPhone 17 Pro Max"
        ],
        "iPad":        [
            "iPad 7a Gen",
            "iPad 8a Gen",
            "iPad 9a Gen",
            "iPad 10a Gen",
            "iPad mini 5a Gen",
            "iPad mini 6",
            "iPad mini 7",
            "iPad Air 3a Gen",
            "iPad Air 4a Gen",
            "iPad Air 5a Gen (M1)",
            "iPad Air 11 M2",
            "iPad Air 13 M2",
            "iPad Pro 12.9 M1",
            "iPad Pro 11 M2",
            "iPad Pro 12.9 M2",
            "iPad Pro 11 M4",
            "iPad Pro 13 M4"
        ],
        "Mac":         [
            "MacBook Air 13 M2",
            "MacBook Air 13 M3",
            "MacBook Air 13 M4",
            "MacBook Air 15 M3",
            "MacBook Air 15 M4",
            "MacBook Pro 14 M1 Pro",
            "MacBook Pro 16 M1 Max",
            "MacBook Pro 14 M3 Pro",
            "MacBook Pro 16 M3 Max",
            "MacBook Pro 14 M4 Pro",
            "MacBook Pro 16 M4 Pro",
            "MacBook Pro 14 M5",
            "MacBook Pro 16 M5",
            "iMac 24 M3",
            "Mac mini M1",
            "Mac mini M2",
            "Mac mini M4",
            "Mac mini M4 Pro",
            "Mac Studio M4 Max",
            "Mac Pro M4 Ultra"
        ],
        "Apple Watch": [
            "Apple Watch Series 6",
            "Apple Watch SE 1",
            "Apple Watch Series 7",
            "Apple Watch Series 8",
            "Apple Watch SE 2",
            "Apple Watch Nike Series 8",
            "Apple Watch Hermes Series 8",
            "Apple Watch Series 9",
            "Apple Watch Nike Series 9",
            "Apple Watch Hermes Series 9",
            "Apple Watch Ultra 2",
            "Apple Watch Series 10",
            "Apple Watch SE 3",
            "Apple Watch Series 11",
            "Apple Watch Ultra 3"
        ],
        "AirPods":     [
            "AirPods 2a Gen",
            "AirPods 3a Gen",
            "AirPods Pro 1a Gen",
            "AirPods Pro 2 Lightning",
            "AirPods Pro 2 USB-C",
            "AirPods Pro 3",
            "AirPods 4",
            "AirPods 4 con ANC",
            "AirPods Max (Lightning)",
            "AirPods Max USB-C"
        ],
    ]
}
