// GeminiManager.swift - Gestor con Chat Conversacional (llamada DIRECTA a Gemini API)
//
// ⚠️ IMPORTANTE: esta versión llama directamente a la API de Gemini desde el
// dispositivo, sin pasar por Firebase Functions. Esto es más simple y no
// necesita facturación de Firebase/Google Cloud, PERO la API key queda
// dentro del binario de la app. Para un proyecto de tesis / demo esto es
// aceptable; para producción real se recomienda volver al enfoque con
// Cloud Function (API key solo en el servidor).
import Foundation
import SwiftUI

@MainActor
class GeminiManager: ObservableObject {
    static let shared = GeminiManager()

    @Published var lastResponse = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var conversationHistory: [ChatMessage] = []

    // ✅ Estructura de mensaje para el chat
    struct ChatMessage: Identifiable, Codable {
        let id: UUID
        let role: String  // "user" o "model"
        let text: String
        let timestamp: Date

        init(role: String, text: String) {
            self.id = UUID()
            self.role = role
            self.text = text
            self.timestamp = Date()
        }
    }

    // 🔑 La API key vive en Secrets.swift (archivo que NO se sube a git).
    private let apiKey = Secrets.geminiAPIKey

    private let model = "gemini-flash-latest"

    // MARK: - Catálogo real de repuestos (extraído de RepairData.swift)
    // Formato por línea: Nombre|Precio|Modelo(s) compatibles|Tiempo de reparación|Disponibilidad
    private let repairCatalog = """
    Pantalla iPhone 12|S/800|iPhone 12|45-60 min|disponible
    Bateria iPhone 12|S/350|iPhone 12|30-40 min|disponible
    Camara Trasera iPhone 12|S/280|iPhone 12|40-50 min|disponible
    Camara Frontal iPhone 12|S/220|iPhone 12|30-40 min|disponible
    Modulo Face ID iPhone 12|S/350|iPhone 12|60-90 min|disponible
    Puerto de Carga iPhone 12|S/200|iPhone 12|30-45 min|disponible
    Altavoces iPhone 12|S/220|iPhone 12|30-40 min|disponible
    Taptic Engine iPhone 12|S/230|iPhone 12|30-40 min|disponible
    Tapa Trasera iPhone 12|S/260|iPhone 12|50-70 min|disponible
    Pantalla iPhone 12 Pro|S/950|iPhone 12 Pro|45-60 min|disponible
    Bateria iPhone 12 Pro|S/380|iPhone 12 Pro|30-40 min|disponible
    Camara Trasera iPhone 12 Pro|S/310|iPhone 12 Pro|40-50 min|disponible
    Camara Frontal iPhone 12 Pro|S/240|iPhone 12 Pro|30-40 min|disponible
    Modulo Face ID iPhone 12 Pro|S/380|iPhone 12 Pro|60-90 min|disponible
    Puerto de Carga iPhone 12 Pro|S/215|iPhone 12 Pro|30-45 min|disponible
    Altavoces iPhone 12 Pro|S/235|iPhone 12 Pro|30-40 min|disponible
    Taptic Engine iPhone 12 Pro|S/245|iPhone 12 Pro|30-40 min|disponible
    Tapa Trasera iPhone 12 Pro|S/285|iPhone 12 Pro|50-70 min|disponible
    Pantalla iPhone 12 Pro Max|S/1150|iPhone 12 Pro Max|45-60 min|disponible
    Bateria iPhone 12 Pro Max|S/420|iPhone 12 Pro Max|30-40 min|disponible
    Camara Trasera iPhone 12 Pro Max|S/350|iPhone 12 Pro Max|40-50 min|disponible
    Camara Frontal iPhone 12 Pro Max|S/270|iPhone 12 Pro Max|30-40 min|disponible
    Modulo Face ID iPhone 12 Pro Max|S/420|iPhone 12 Pro Max|60-90 min|disponible
    Puerto de Carga iPhone 12 Pro Max|S/230|iPhone 12 Pro Max|30-45 min|disponible
    Altavoces iPhone 12 Pro Max|S/255|iPhone 12 Pro Max|30-40 min|disponible
    Taptic Engine iPhone 12 Pro Max|S/265|iPhone 12 Pro Max|30-40 min|disponible
    Tapa Trasera iPhone 12 Pro Max|S/320|iPhone 12 Pro Max|50-70 min|disponible
    Pantalla iPhone 13 Mini|S/800|iPhone 13 Mini|45-60 min|disponible
    Bateria iPhone 13 Mini|S/340|iPhone 13 Mini|30-40 min|disponible
    Camara Trasera iPhone 13 Mini|S/260|iPhone 13 Mini|40-50 min|disponible
    Camara Frontal iPhone 13 Mini|S/210|iPhone 13 Mini|30-40 min|disponible
    Modulo Face ID iPhone 13 Mini|S/340|iPhone 13 Mini|60-90 min|disponible
    Puerto de Carga iPhone 13 Mini|S/195|iPhone 13 Mini|30-45 min|disponible
    Altavoces iPhone 13 Mini|S/210|iPhone 13 Mini|30-40 min|disponible
    Taptic Engine iPhone 13 Mini|S/220|iPhone 13 Mini|30-40 min|disponible
    Tapa Trasera iPhone 13 Mini|S/250|iPhone 13 Mini|50-70 min|disponible
    Pantalla iPhone 13|S/950|iPhone 13|45-60 min|disponible
    Bateria iPhone 13|S/370|iPhone 13|30-40 min|disponible
    Camara Trasera iPhone 13|S/300|iPhone 13|40-50 min|disponible
    Camara Frontal iPhone 13|S/235|iPhone 13|30-40 min|disponible
    Modulo Face ID iPhone 13|S/370|iPhone 13|60-90 min|disponible
    Puerto de Carga iPhone 13|S/210|iPhone 13|30-45 min|disponible
    Altavoces iPhone 13|S/230|iPhone 13|30-40 min|disponible
    Taptic Engine iPhone 13|S/240|iPhone 13|30-40 min|disponible
    Tapa Trasera iPhone 13|S/275|iPhone 13|50-70 min|disponible
    Pantalla iPhone 13 Pro|S/1100|iPhone 13 Pro|45-60 min|disponible
    Bateria iPhone 13 Pro|S/400|iPhone 13 Pro|30-40 min|disponible
    Camara Trasera iPhone 13 Pro|S/330|iPhone 13 Pro|40-50 min|disponible
    Camara Frontal iPhone 13 Pro|S/255|iPhone 13 Pro|30-40 min|disponible
    Modulo Face ID iPhone 13 Pro|S/400|iPhone 13 Pro|60-90 min|disponible
    Puerto de Carga iPhone 13 Pro|S/225|iPhone 13 Pro|30-45 min|disponible
    Altavoces iPhone 13 Pro|S/248|iPhone 13 Pro|30-40 min|disponible
    Taptic Engine iPhone 13 Pro|S/258|iPhone 13 Pro|30-40 min|disponible
    Tapa Trasera iPhone 13 Pro|S/295|iPhone 13 Pro|50-70 min|disponible
    Pantalla iPhone 13 Pro Max|S/1300|iPhone 13 Pro Max|45-60 min|disponible
    Bateria iPhone 13 Pro Max|S/450|iPhone 13 Pro Max|30-40 min|disponible
    Camara Trasera iPhone 13 Pro Max|S/370|iPhone 13 Pro Max|40-50 min|disponible
    Camara Frontal iPhone 13 Pro Max|S/285|iPhone 13 Pro Max|30-40 min|disponible
    Modulo Face ID iPhone 13 Pro Max|S/450|iPhone 13 Pro Max|60-90 min|disponible
    Puerto de Carga iPhone 13 Pro Max|S/250|iPhone 13 Pro Max|30-45 min|disponible
    Altavoces iPhone 13 Pro Max|S/270|iPhone 13 Pro Max|30-40 min|disponible
    Taptic Engine iPhone 13 Pro Max|S/280|iPhone 13 Pro Max|30-40 min|disponible
    Tapa Trasera iPhone 13 Pro Max|S/330|iPhone 13 Pro Max|50-70 min|disponible
    Pantalla iPhone SE (3a Gen)|S/750|iPhone SE (3a Gen)|45-60 min|disponible
    Bateria iPhone SE (3a Gen)|S/320|iPhone SE (3a Gen)|30-40 min|disponible
    Camara Trasera iPhone SE (3a Gen)|S/240|iPhone SE (3a Gen)|40-50 min|disponible
    Camara Frontal iPhone SE (3a Gen)|S/200|iPhone SE (3a Gen)|30-40 min|disponible
    Modulo Face ID iPhone SE (3a Gen)|S/310|iPhone SE (3a Gen)|60-90 min|disponible
    Puerto de Carga iPhone SE (3a Gen)|S/185|iPhone SE (3a Gen)|30-45 min|disponible
    Altavoces iPhone SE (3a Gen)|S/200|iPhone SE (3a Gen)|30-40 min|disponible
    Taptic Engine iPhone SE (3a Gen)|S/210|iPhone SE (3a Gen)|30-40 min|disponible
    Tapa Trasera iPhone SE (3a Gen)|S/240|iPhone SE (3a Gen)|50-70 min|disponible
    Pantalla iPhone 14|S/1300|iPhone 14|45-60 min|disponible
    Bateria iPhone 14|S/420|iPhone 14|30-40 min|disponible
    Camara Trasera iPhone 14|S/350|iPhone 14|40-50 min|disponible
    Camara Frontal iPhone 14|S/270|iPhone 14|30-40 min|disponible
    Modulo Face ID iPhone 14|S/410|iPhone 14|60-90 min|disponible
    Puerto de Carga iPhone 14|S/230|iPhone 14|30-45 min|disponible
    Altavoces iPhone 14|S/255|iPhone 14|30-40 min|disponible
    Taptic Engine iPhone 14|S/265|iPhone 14|30-40 min|disponible
    Tapa Trasera iPhone 14|S/310|iPhone 14|50-70 min|disponible
    Pantalla iPhone 14 Plus|S/1450|iPhone 14 Plus|45-60 min|disponible
    Bateria iPhone 14 Plus|S/450|iPhone 14 Plus|30-40 min|disponible
    Camara Trasera iPhone 14 Plus|S/370|iPhone 14 Plus|40-50 min|disponible
    Camara Frontal iPhone 14 Plus|S/285|iPhone 14 Plus|30-40 min|disponible
    Modulo Face ID iPhone 14 Plus|S/430|iPhone 14 Plus|60-90 min|disponible
    Puerto de Carga iPhone 14 Plus|S/245|iPhone 14 Plus|30-45 min|disponible
    Altavoces iPhone 14 Plus|S/268|iPhone 14 Plus|30-40 min|disponible
    Taptic Engine iPhone 14 Plus|S/278|iPhone 14 Plus|30-40 min|disponible
    Tapa Trasera iPhone 14 Plus|S/325|iPhone 14 Plus|50-70 min|disponible
    Pantalla iPhone 14 Pro|S/1550|iPhone 14 Pro|45-60 min|disponible
    Bateria iPhone 14 Pro|S/470|iPhone 14 Pro|30-40 min|disponible
    Camara Trasera iPhone 14 Pro|S/390|iPhone 14 Pro|40-50 min|disponible
    Camara Frontal iPhone 14 Pro|S/300|iPhone 14 Pro|30-40 min|disponible
    Modulo Face ID iPhone 14 Pro|S/450|iPhone 14 Pro|60-90 min|disponible
    Puerto de Carga iPhone 14 Pro|S/255|iPhone 14 Pro|30-45 min|disponible
    Altavoces iPhone 14 Pro|S/278|iPhone 14 Pro|30-40 min|disponible
    Taptic Engine iPhone 14 Pro|S/290|iPhone 14 Pro|30-40 min|disponible
    Tapa Trasera iPhone 14 Pro|S/340|iPhone 14 Pro|50-70 min|disponible
    Pantalla iPhone 14 Pro Max|S/1800|iPhone 14 Pro Max|45-60 min|disponible
    Bateria iPhone 14 Pro Max|S/520|iPhone 14 Pro Max|30-40 min|disponible
    Camara Trasera iPhone 14 Pro Max|S/430|iPhone 14 Pro Max|40-50 min|disponible
    Camara Frontal iPhone 14 Pro Max|S/330|iPhone 14 Pro Max|30-40 min|disponible
    Modulo Face ID iPhone 14 Pro Max|S/490|iPhone 14 Pro Max|60-90 min|disponible
    Puerto de Carga iPhone 14 Pro Max|S/275|iPhone 14 Pro Max|30-45 min|disponible
    Altavoces iPhone 14 Pro Max|S/300|iPhone 14 Pro Max|30-40 min|disponible
    Taptic Engine iPhone 14 Pro Max|S/312|iPhone 14 Pro Max|30-40 min|disponible
    Tapa Trasera iPhone 14 Pro Max|S/370|iPhone 14 Pro Max|50-70 min|disponible
    Pantalla iPhone 15|S/1600|iPhone 15|45-60 min|disponible
    Bateria iPhone 15|S/460|iPhone 15|30-40 min|disponible
    Camara Trasera iPhone 15|S/390|iPhone 15|40-50 min|disponible
    Camara Frontal iPhone 15|S/300|iPhone 15|30-40 min|disponible
    Modulo Face ID iPhone 15|S/440|iPhone 15|60-90 min|disponible
    Puerto de Carga iPhone 15|S/255|iPhone 15|30-45 min|disponible
    Altavoces iPhone 15|S/280|iPhone 15|30-40 min|disponible
    Taptic Engine iPhone 15|S/290|iPhone 15|30-40 min|disponible
    Tapa Trasera iPhone 15|S/355|iPhone 15|50-70 min|disponible
    Pantalla iPhone 15 Plus|S/1800|iPhone 15 Plus|45-60 min|disponible
    Bateria iPhone 15 Plus|S/490|iPhone 15 Plus|30-40 min|disponible
    Camara Trasera iPhone 15 Plus|S/415|iPhone 15 Plus|40-50 min|disponible
    Camara Frontal iPhone 15 Plus|S/315|iPhone 15 Plus|30-40 min|disponible
    Modulo Face ID iPhone 15 Plus|S/460|iPhone 15 Plus|60-90 min|disponible
    Puerto de Carga iPhone 15 Plus|S/268|iPhone 15 Plus|30-45 min|disponible
    Altavoces iPhone 15 Plus|S/293|iPhone 15 Plus|30-40 min|disponible
    Taptic Engine iPhone 15 Plus|S/305|iPhone 15 Plus|30-40 min|disponible
    Tapa Trasera iPhone 15 Plus|S/375|iPhone 15 Plus|50-70 min|disponible
    Pantalla iPhone 15 Pro|S/1950|iPhone 15 Pro|45-60 min|disponible
    Bateria iPhone 15 Pro|S/510|iPhone 15 Pro|30-40 min|disponible
    Camara Trasera iPhone 15 Pro|S/435|iPhone 15 Pro|40-50 min|disponible
    Camara Frontal iPhone 15 Pro|S/330|iPhone 15 Pro|30-40 min|disponible
    Modulo Face ID iPhone 15 Pro|S/480|iPhone 15 Pro|60-90 min|disponible
    Puerto de Carga iPhone 15 Pro|S/280|iPhone 15 Pro|30-45 min|disponible
    Altavoces iPhone 15 Pro|S/308|iPhone 15 Pro|30-40 min|disponible
    Taptic Engine iPhone 15 Pro|S/320|iPhone 15 Pro|30-40 min|disponible
    Tapa Trasera iPhone 15 Pro|S/390|iPhone 15 Pro|50-70 min|disponible
    Pantalla iPhone 15 Pro Max|S/2200|iPhone 15 Pro Max|45-60 min|disponible
    Bateria iPhone 15 Pro Max|S/560|iPhone 15 Pro Max|30-40 min|disponible
    Camara Trasera iPhone 15 Pro Max|S/475|iPhone 15 Pro Max|40-50 min|disponible
    Camara Frontal iPhone 15 Pro Max|S/360|iPhone 15 Pro Max|30-40 min|disponible
    Modulo Face ID iPhone 15 Pro Max|S/520|iPhone 15 Pro Max|60-90 min|disponible
    Puerto de Carga iPhone 15 Pro Max|S/305|iPhone 15 Pro Max|30-45 min|disponible
    Altavoces iPhone 15 Pro Max|S/335|iPhone 15 Pro Max|30-40 min|disponible
    Taptic Engine iPhone 15 Pro Max|S/348|iPhone 15 Pro Max|30-40 min|disponible
    Tapa Trasera iPhone 15 Pro Max|S/425|iPhone 15 Pro Max|50-70 min|disponible
    Pantalla iPhone 16|S/1700|iPhone 16|45-60 min|disponible
    Bateria iPhone 16|S/470|iPhone 16|30-40 min|disponible
    Camara Trasera iPhone 16|S/400|iPhone 16|40-50 min|disponible
    Camara Frontal iPhone 16|S/308|iPhone 16|30-40 min|disponible
    Modulo Face ID iPhone 16|S/455|iPhone 16|60-90 min|disponible
    Puerto de Carga iPhone 16|S/260|iPhone 16|30-45 min|disponible
    Altavoces iPhone 16|S/285|iPhone 16|30-40 min|disponible
    Taptic Engine iPhone 16|S/295|iPhone 16|30-40 min|disponible
    Tapa Trasera iPhone 16|S/362|iPhone 16|50-70 min|disponible
    Pantalla iPhone 16 Plus|S/1900|iPhone 16 Plus|45-60 min|disponible
    Bateria iPhone 16 Plus|S/500|iPhone 16 Plus|30-40 min|disponible
    Camara Trasera iPhone 16 Plus|S/425|iPhone 16 Plus|40-50 min|disponible
    Camara Frontal iPhone 16 Plus|S/325|iPhone 16 Plus|30-40 min|disponible
    Modulo Face ID iPhone 16 Plus|S/475|iPhone 16 Plus|60-90 min|disponible
    Puerto de Carga iPhone 16 Plus|S/272|iPhone 16 Plus|30-45 min|disponible
    Altavoces iPhone 16 Plus|S/298|iPhone 16 Plus|30-40 min|disponible
    Taptic Engine iPhone 16 Plus|S/308|iPhone 16 Plus|30-40 min|disponible
    Tapa Trasera iPhone 16 Plus|S/380|iPhone 16 Plus|50-70 min|disponible
    Pantalla iPhone 16 Pro|S/2100|iPhone 16 Pro|45-60 min|disponible
    Bateria iPhone 16 Pro|S/540|iPhone 16 Pro|30-40 min|disponible
    Camara Trasera iPhone 16 Pro|S/450|iPhone 16 Pro|40-50 min|disponible
    Camara Frontal iPhone 16 Pro|S/345|iPhone 16 Pro|30-40 min|disponible
    Modulo Face ID iPhone 16 Pro|S/500|iPhone 16 Pro|60-90 min|disponible
    Puerto de Carga iPhone 16 Pro|S/288|iPhone 16 Pro|30-45 min|disponible
    Altavoces iPhone 16 Pro|S/315|iPhone 16 Pro|30-40 min|disponible
    Taptic Engine iPhone 16 Pro|S/328|iPhone 16 Pro|30-40 min|disponible
    Tapa Trasera iPhone 16 Pro|S/400|iPhone 16 Pro|50-70 min|disponible
    Pantalla iPhone 16 Pro Max|S/2400|iPhone 16 Pro Max|45-60 min|disponible
    Bateria iPhone 16 Pro Max|S/590|iPhone 16 Pro Max|30-40 min|disponible
    Camara Trasera iPhone 16 Pro Max|S/490|iPhone 16 Pro Max|40-50 min|disponible
    Camara Frontal iPhone 16 Pro Max|S/375|iPhone 16 Pro Max|30-40 min|disponible
    Modulo Face ID iPhone 16 Pro Max|S/540|iPhone 16 Pro Max|60-90 min|disponible
    Puerto de Carga iPhone 16 Pro Max|S/312|iPhone 16 Pro Max|30-45 min|disponible
    Altavoces iPhone 16 Pro Max|S/342|iPhone 16 Pro Max|30-40 min|disponible
    Taptic Engine iPhone 16 Pro Max|S/355|iPhone 16 Pro Max|30-40 min|disponible
    Tapa Trasera iPhone 16 Pro Max|S/435|iPhone 16 Pro Max|50-70 min|disponible
    Pantalla iPhone 16e|S/1350|iPhone 16e|45-60 min|disponible
    Bateria iPhone 16e|S/430|iPhone 16e|30-40 min|disponible
    Camara Trasera iPhone 16e|S/360|iPhone 16e|40-50 min|disponible
    Camara Frontal iPhone 16e|S/278|iPhone 16e|30-40 min|disponible
    Modulo Face ID iPhone 16e|S/420|iPhone 16e|60-90 min|disponible
    Puerto de Carga iPhone 16e|S/238|iPhone 16e|30-45 min|disponible
    Altavoces iPhone 16e|S/260|iPhone 16e|30-40 min|disponible
    Taptic Engine iPhone 16e|S/270|iPhone 16e|30-40 min|disponible
    Tapa Trasera iPhone 16e|S/318|iPhone 16e|50-70 min|disponible
    Pantalla iPhone 17e|S/1400|iPhone 17e|45-60 min|disponible
    Bateria iPhone 17e|S/440|iPhone 17e|30-40 min|disponible
    Camara Trasera iPhone 17e|S/368|iPhone 17e|40-50 min|disponible
    Camara Frontal iPhone 17e|S/282|iPhone 17e|30-40 min|disponible
    Modulo Face ID iPhone 17e|S/428|iPhone 17e|60-90 min|disponible
    Puerto de Carga iPhone 17e|S/242|iPhone 17e|30-45 min|disponible
    Altavoces iPhone 17e|S/264|iPhone 17e|30-40 min|disponible
    Taptic Engine iPhone 17e|S/274|iPhone 17e|30-40 min|disponible
    Tapa Trasera iPhone 17e|S/322|iPhone 17e|50-70 min|disponible
    Pantalla iPhone 17|S/1800|iPhone 17|45-60 min|disponible
    Bateria iPhone 17|S/490|iPhone 17|30-40 min|disponible
    Camara Trasera iPhone 17|S/415|iPhone 17|40-50 min|disponible
    Camara Frontal iPhone 17|S/318|iPhone 17|30-40 min|disponible
    Modulo Face ID iPhone 17|S/468|iPhone 17|60-90 min|disponible
    Puerto de Carga iPhone 17|S/265|iPhone 17|30-45 min|disponible
    Altavoces iPhone 17|S/290|iPhone 17|30-40 min|disponible
    Taptic Engine iPhone 17|S/300|iPhone 17|30-40 min|disponible
    Tapa Trasera iPhone 17|S/368|iPhone 17|50-70 min|disponible
    Pantalla iPhone Air|S/2000|iPhone Air|45-60 min|disponible
    Bateria iPhone Air|S/520|iPhone Air|30-40 min|disponible
    Camara Trasera iPhone Air|S/440|iPhone Air|40-50 min|disponible
    Camara Frontal iPhone Air|S/335|iPhone Air|30-40 min|disponible
    Modulo Face ID iPhone Air|S/485|iPhone Air|60-90 min|disponible
    Puerto de Carga iPhone Air|S/275|iPhone Air|30-45 min|disponible
    Altavoces iPhone Air|S/302|iPhone Air|30-40 min|disponible
    Taptic Engine iPhone Air|S/315|iPhone Air|30-40 min|disponible
    Tapa Trasera iPhone Air|S/382|iPhone Air|50-70 min|disponible
    Pantalla iPhone 17 Pro|S/2200|iPhone 17 Pro|45-60 min|disponible
    Bateria iPhone 17 Pro|S/550|iPhone 17 Pro|30-40 min|disponible
    Camara Trasera iPhone 17 Pro|S/460|iPhone 17 Pro|40-50 min|disponible
    Camara Frontal iPhone 17 Pro|S/348|iPhone 17 Pro|30-40 min|disponible
    Modulo Face ID iPhone 17 Pro|S/505|iPhone 17 Pro|60-90 min|disponible
    Puerto de Carga iPhone 17 Pro|S/288|iPhone 17 Pro|30-45 min|disponible
    Altavoces iPhone 17 Pro|S/316|iPhone 17 Pro|30-40 min|disponible
    Taptic Engine iPhone 17 Pro|S/330|iPhone 17 Pro|30-40 min|disponible
    Tapa Trasera iPhone 17 Pro|S/398|iPhone 17 Pro|50-70 min|disponible
    Pantalla iPhone 17 Pro Max|S/2500|iPhone 17 Pro Max|45-60 min|disponible
    Bateria iPhone 17 Pro Max|S/600|iPhone 17 Pro Max|30-40 min|disponible
    Camara Trasera iPhone 17 Pro Max|S/500|iPhone 17 Pro Max|40-50 min|disponible
    Camara Frontal iPhone 17 Pro Max|S/378|iPhone 17 Pro Max|30-40 min|disponible
    Modulo Face ID iPhone 17 Pro Max|S/545|iPhone 17 Pro Max|60-90 min|disponible
    Puerto de Carga iPhone 17 Pro Max|S/310|iPhone 17 Pro Max|30-45 min|disponible
    Altavoces iPhone 17 Pro Max|S/340|iPhone 17 Pro Max|30-40 min|disponible
    Taptic Engine iPhone 17 Pro Max|S/355|iPhone 17 Pro Max|30-40 min|disponible
    Tapa Trasera iPhone 17 Pro Max|S/432|iPhone 17 Pro Max|50-70 min|disponible
    Pantalla iPad 7a Gen|S/700|iPad 7a Gen|60-80 min|disponible
    Bateria iPad 7a Gen|S/280|iPad 7a Gen|45-60 min|disponible
    Camara Trasera iPad 7a Gen|S/210|iPad 7a Gen|40-55 min|disponible
    Camara Frontal iPad 7a Gen|S/180|iPad 7a Gen|35-50 min|disponible
    Puerto USB-C iPad 7a Gen|S/170|iPad 7a Gen|35-50 min|disponible
    Altavoces iPad 7a Gen|S/230|iPad 7a Gen|40-55 min|disponible
    Tapa Trasera iPad 7a Gen|S/160|iPad 7a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad 7a Gen|S/160|iPad 7a Gen|45-60 min|disponible
    Pantalla iPad 8a Gen|S/750|iPad 8a Gen|60-80 min|disponible
    Bateria iPad 8a Gen|S/295|iPad 8a Gen|45-60 min|disponible
    Camara Trasera iPad 8a Gen|S/220|iPad 8a Gen|40-55 min|disponible
    Camara Frontal iPad 8a Gen|S/185|iPad 8a Gen|35-50 min|disponible
    Puerto USB-C iPad 8a Gen|S/175|iPad 8a Gen|35-50 min|disponible
    Altavoces iPad 8a Gen|S/245|iPad 8a Gen|40-55 min|disponible
    Tapa Trasera iPad 8a Gen|S/168|iPad 8a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad 8a Gen|S/160|iPad 8a Gen|45-60 min|disponible
    Pantalla iPad 9a Gen|S/800|iPad 9a Gen|60-80 min|disponible
    Bateria iPad 9a Gen|S/310|iPad 9a Gen|45-60 min|disponible
    Camara Trasera iPad 9a Gen|S/232|iPad 9a Gen|40-55 min|disponible
    Camara Frontal iPad 9a Gen|S/192|iPad 9a Gen|35-50 min|disponible
    Puerto USB-C iPad 9a Gen|S/182|iPad 9a Gen|35-50 min|disponible
    Altavoces iPad 9a Gen|S/258|iPad 9a Gen|40-55 min|disponible
    Tapa Trasera iPad 9a Gen|S/175|iPad 9a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad 9a Gen|S/160|iPad 9a Gen|45-60 min|disponible
    Pantalla iPad 10a Gen|S/900|iPad 10a Gen|60-80 min|disponible
    Bateria iPad 10a Gen|S/345|iPad 10a Gen|45-60 min|disponible
    Camara Trasera iPad 10a Gen|S/258|iPad 10a Gen|40-55 min|disponible
    Camara Frontal iPad 10a Gen|S/208|iPad 10a Gen|35-50 min|disponible
    Puerto USB-C iPad 10a Gen|S/198|iPad 10a Gen|35-50 min|disponible
    Altavoces iPad 10a Gen|S/285|iPad 10a Gen|40-55 min|disponible
    Tapa Trasera iPad 10a Gen|S/190|iPad 10a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad 10a Gen|S/160|iPad 10a Gen|45-60 min|disponible
    Pantalla iPad mini 5a Gen|S/850|iPad mini 5a Gen|60-80 min|disponible
    Bateria iPad mini 5a Gen|S/320|iPad mini 5a Gen|45-60 min|disponible
    Camara Trasera iPad mini 5a Gen|S/240|iPad mini 5a Gen|40-55 min|disponible
    Camara Frontal iPad mini 5a Gen|S/198|iPad mini 5a Gen|35-50 min|disponible
    Puerto USB-C iPad mini 5a Gen|S/188|iPad mini 5a Gen|35-50 min|disponible
    Altavoces iPad mini 5a Gen|S/268|iPad mini 5a Gen|40-55 min|disponible
    Tapa Trasera iPad mini 5a Gen|S/178|iPad mini 5a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad mini 5a Gen|S/160|iPad mini 5a Gen|45-60 min|disponible
    Pantalla iPad mini 6|S/950|iPad mini 6|60-80 min|disponible
    Bateria iPad mini 6|S/360|iPad mini 6|45-60 min|disponible
    Camara Trasera iPad mini 6|S/268|iPad mini 6|40-55 min|disponible
    Camara Frontal iPad mini 6|S/218|iPad mini 6|35-50 min|disponible
    Puerto USB-C iPad mini 6|S/208|iPad mini 6|35-50 min|disponible
    Altavoces iPad mini 6|S/298|iPad mini 6|40-55 min|disponible
    Tapa Trasera iPad mini 6|S/198|iPad mini 6|60-90 min|disponible
    Conector Smart Keyboard iPad mini 6|S/168|iPad mini 6|45-60 min|disponible
    Pantalla iPad mini 7|S/1020|iPad mini 7|60-80 min|disponible
    Bateria iPad mini 7|S/385|iPad mini 7|45-60 min|disponible
    Camara Trasera iPad mini 7|S/288|iPad mini 7|40-55 min|disponible
    Camara Frontal iPad mini 7|S/232|iPad mini 7|35-50 min|disponible
    Puerto USB-C iPad mini 7|S/222|iPad mini 7|35-50 min|disponible
    Altavoces iPad mini 7|S/318|iPad mini 7|40-55 min|disponible
    Tapa Trasera iPad mini 7|S/210|iPad mini 7|60-90 min|disponible
    Conector Smart Keyboard iPad mini 7|S/180|iPad mini 7|45-60 min|disponible
    Pantalla iPad Air 3a Gen|S/880|iPad Air 3a Gen|60-80 min|disponible
    Bateria iPad Air 3a Gen|S/335|iPad Air 3a Gen|45-60 min|disponible
    Camara Trasera iPad Air 3a Gen|S/250|iPad Air 3a Gen|40-55 min|disponible
    Camara Frontal iPad Air 3a Gen|S/205|iPad Air 3a Gen|35-50 min|disponible
    Puerto USB-C iPad Air 3a Gen|S/195|iPad Air 3a Gen|35-50 min|disponible
    Altavoces iPad Air 3a Gen|S/272|iPad Air 3a Gen|40-55 min|disponible
    Tapa Trasera iPad Air 3a Gen|S/182|iPad Air 3a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad Air 3a Gen|S/160|iPad Air 3a Gen|45-60 min|disponible
    Pantalla iPad Air 4a Gen|S/980|iPad Air 4a Gen|60-80 min|disponible
    Bateria iPad Air 4a Gen|S/368|iPad Air 4a Gen|45-60 min|disponible
    Camara Trasera iPad Air 4a Gen|S/275|iPad Air 4a Gen|40-55 min|disponible
    Camara Frontal iPad Air 4a Gen|S/222|iPad Air 4a Gen|35-50 min|disponible
    Puerto USB-C iPad Air 4a Gen|S/212|iPad Air 4a Gen|35-50 min|disponible
    Altavoces iPad Air 4a Gen|S/302|iPad Air 4a Gen|40-55 min|disponible
    Tapa Trasera iPad Air 4a Gen|S/202|iPad Air 4a Gen|60-90 min|disponible
    Conector Smart Keyboard iPad Air 4a Gen|S/172|iPad Air 4a Gen|45-60 min|disponible
    Pantalla iPad Air 5a Gen (M1)|S/1100|iPad Air 5a Gen (M1)|60-80 min|disponible
    Bateria iPad Air 5a Gen (M1)|S/405|iPad Air 5a Gen (M1)|45-60 min|disponible
    Camara Trasera iPad Air 5a Gen (M1)|S/302|iPad Air 5a Gen (M1)|40-55 min|disponible
    Camara Frontal iPad Air 5a Gen (M1)|S/245|iPad Air 5a Gen (M1)|35-50 min|disponible
    Puerto USB-C iPad Air 5a Gen (M1)|S/235|iPad Air 5a Gen (M1)|35-50 min|disponible
    Altavoces iPad Air 5a Gen (M1)|S/335|iPad Air 5a Gen (M1)|40-55 min|disponible
    Tapa Trasera iPad Air 5a Gen (M1)|S/222|iPad Air 5a Gen (M1)|60-90 min|disponible
    Conector Smart Keyboard iPad Air 5a Gen (M1)|S/192|iPad Air 5a Gen (M1)|45-60 min|disponible
    Pantalla iPad Air 11 M2|S/1250|iPad Air 11 M2|60-80 min|disponible
    Bateria iPad Air 11 M2|S/445|iPad Air 11 M2|45-60 min|disponible
    Camara Trasera iPad Air 11 M2|S/332|iPad Air 11 M2|40-55 min|disponible
    Camara Frontal iPad Air 11 M2|S/268|iPad Air 11 M2|35-50 min|disponible
    Puerto USB-C iPad Air 11 M2|S/258|iPad Air 11 M2|35-50 min|disponible
    Altavoces iPad Air 11 M2|S/368|iPad Air 11 M2|40-55 min|disponible
    Tapa Trasera iPad Air 11 M2|S/240|iPad Air 11 M2|60-90 min|disponible
    Conector Smart Keyboard iPad Air 11 M2|S/210|iPad Air 11 M2|45-60 min|disponible
    Pantalla iPad Air 13 M2|S/1350|iPad Air 13 M2|60-80 min|disponible
    Bateria iPad Air 13 M2|S/475|iPad Air 13 M2|45-60 min|disponible
    Camara Trasera iPad Air 13 M2|S/355|iPad Air 13 M2|40-55 min|disponible
    Camara Frontal iPad Air 13 M2|S/285|iPad Air 13 M2|35-50 min|disponible
    Puerto USB-C iPad Air 13 M2|S/272|iPad Air 13 M2|35-50 min|disponible
    Altavoces iPad Air 13 M2|S/392|iPad Air 13 M2|40-55 min|disponible
    Tapa Trasera iPad Air 13 M2|S/255|iPad Air 13 M2|60-90 min|disponible
    Conector Smart Keyboard iPad Air 13 M2|S/225|iPad Air 13 M2|45-60 min|disponible
    Pantalla iPad Pro 12.9 M1|S/1500|iPad Pro 12.9 M1|60-80 min|disponible
    Bateria iPad Pro 12.9 M1|S/520|iPad Pro 12.9 M1|45-60 min|disponible
    Camara Trasera iPad Pro 12.9 M1|S/388|iPad Pro 12.9 M1|40-55 min|disponible
    Camara Frontal iPad Pro 12.9 M1|S/315|iPad Pro 12.9 M1|35-50 min|disponible
    Puerto USB-C iPad Pro 12.9 M1|S/300|iPad Pro 12.9 M1|35-50 min|disponible
    Altavoces iPad Pro 12.9 M1|S/425|iPad Pro 12.9 M1|40-55 min|disponible
    Tapa Trasera iPad Pro 12.9 M1|S/278|iPad Pro 12.9 M1|60-90 min|disponible
    Conector Magic Keyboard iPad Pro 12.9 M1|S/248|iPad Pro 12.9 M1|45-60 min|disponible
    Pantalla iPad Pro 11 M2|S/1600|iPad Pro 11 M2|60-80 min|disponible
    Bateria iPad Pro 11 M2|S/550|iPad Pro 11 M2|45-60 min|disponible
    Camara Trasera iPad Pro 11 M2|S/410|iPad Pro 11 M2|40-55 min|disponible
    Camara Frontal iPad Pro 11 M2|S/332|iPad Pro 11 M2|35-50 min|disponible
    Puerto USB-C iPad Pro 11 M2|S/318|iPad Pro 11 M2|35-50 min|disponible
    Altavoces iPad Pro 11 M2|S/448|iPad Pro 11 M2|40-55 min|disponible
    Tapa Trasera iPad Pro 11 M2|S/292|iPad Pro 11 M2|60-90 min|disponible
    Conector Magic Keyboard iPad Pro 11 M2|S/262|iPad Pro 11 M2|45-60 min|disponible
    Pantalla iPad Pro 12.9 M2|S/1700|iPad Pro 12.9 M2|60-80 min|disponible
    Bateria iPad Pro 12.9 M2|S/585|iPad Pro 12.9 M2|45-60 min|disponible
    Camara Trasera iPad Pro 12.9 M2|S/435|iPad Pro 12.9 M2|40-55 min|disponible
    Camara Frontal iPad Pro 12.9 M2|S/352|iPad Pro 12.9 M2|35-50 min|disponible
    Puerto USB-C iPad Pro 12.9 M2|S/338|iPad Pro 12.9 M2|35-50 min|disponible
    Altavoces iPad Pro 12.9 M2|S/475|iPad Pro 12.9 M2|40-55 min|disponible
    Tapa Trasera iPad Pro 12.9 M2|S/308|iPad Pro 12.9 M2|60-90 min|disponible
    Conector Magic Keyboard iPad Pro 12.9 M2|S/278|iPad Pro 12.9 M2|45-60 min|disponible
    Pantalla iPad Pro 11 M4|S/1800|iPad Pro 11 M4|60-80 min|disponible
    Bateria iPad Pro 11 M4|S/620|iPad Pro 11 M4|45-60 min|disponible
    Camara Trasera iPad Pro 11 M4|S/460|iPad Pro 11 M4|40-55 min|disponible
    Camara Frontal iPad Pro 11 M4|S/372|iPad Pro 11 M4|35-50 min|disponible
    Puerto USB-C iPad Pro 11 M4|S/358|iPad Pro 11 M4|35-50 min|disponible
    Altavoces iPad Pro 11 M4|S/502|iPad Pro 11 M4|40-55 min|disponible
    Tapa Trasera iPad Pro 11 M4|S/325|iPad Pro 11 M4|60-90 min|disponible
    Conector Magic Keyboard iPad Pro 11 M4|S/295|iPad Pro 11 M4|45-60 min|disponible
    Pantalla iPad Pro 13 M4|S/2100|iPad Pro 13 M4|60-80 min|disponible
    Bateria iPad Pro 13 M4|S/700|iPad Pro 13 M4|45-60 min|disponible
    Camara Trasera iPad Pro 13 M4|S/520|iPad Pro 13 M4|40-55 min|disponible
    Camara Frontal iPad Pro 13 M4|S/420|iPad Pro 13 M4|35-50 min|disponible
    Puerto USB-C iPad Pro 13 M4|S/402|iPad Pro 13 M4|35-50 min|disponible
    Altavoces iPad Pro 13 M4|S/568|iPad Pro 13 M4|40-55 min|disponible
    Tapa Trasera iPad Pro 13 M4|S/368|iPad Pro 13 M4|60-90 min|disponible
    Conector Magic Keyboard iPad Pro 13 M4|S/338|iPad Pro 13 M4|45-60 min|disponible
    Pantalla MacBook Air 13 M2|S/2200|MacBook Air 13 M2|90-120 min|disponible
    Bateria MacBook Air 13 M2|S/800|MacBook Air 13 M2|60-80 min|disponible
    Teclado MacBook Air 13 M2|S/650|MacBook Air 13 M2|60-90 min|disponible
    Trackpad MacBook Air 13 M2|S/550|MacBook Air 13 M2|45-70 min|disponible
    Puerto MagSafe 3 MacBook Air 13 M2|S/400|MacBook Air 13 M2|50-70 min|disponible
    Tapa Superior MacBook Air 13 M2|S/900|MacBook Air 13 M2|90-130 min|disponible
    Pantalla MacBook Air 13 M3|S/2450|MacBook Air 13 M3|90-120 min|disponible
    Bateria MacBook Air 13 M3|S/860|MacBook Air 13 M3|60-80 min|disponible
    Teclado MacBook Air 13 M3|S/695|MacBook Air 13 M3|60-90 min|disponible
    Trackpad MacBook Air 13 M3|S/580|MacBook Air 13 M3|45-70 min|disponible
    Puerto MagSafe 3 MacBook Air 13 M3|S/425|MacBook Air 13 M3|50-70 min|disponible
    Tapa Superior MacBook Air 13 M3|S/980|MacBook Air 13 M3|90-130 min|disponible
    Pantalla MacBook Air 13 M4|S/2700|MacBook Air 13 M4|90-120 min|disponible
    Bateria MacBook Air 13 M4|S/920|MacBook Air 13 M4|60-80 min|disponible
    Teclado MacBook Air 13 M4|S/740|MacBook Air 13 M4|60-90 min|disponible
    Trackpad MacBook Air 13 M4|S/615|MacBook Air 13 M4|45-70 min|disponible
    Puerto MagSafe 3 MacBook Air 13 M4|S/450|MacBook Air 13 M4|50-70 min|disponible
    Tapa Superior MacBook Air 13 M4|S/1080|MacBook Air 13 M4|90-130 min|disponible
    Pantalla MacBook Air 15 M3|S/2600|MacBook Air 15 M3|90-120 min|disponible
    Bateria MacBook Air 15 M3|S/890|MacBook Air 15 M3|60-80 min|disponible
    Teclado MacBook Air 15 M3|S/720|MacBook Air 15 M3|60-90 min|disponible
    Trackpad MacBook Air 15 M3|S/600|MacBook Air 15 M3|45-70 min|disponible
    Puerto MagSafe 3 MacBook Air 15 M3|S/440|MacBook Air 15 M3|50-70 min|disponible
    Tapa Superior MacBook Air 15 M3|S/1020|MacBook Air 15 M3|90-130 min|disponible
    Pantalla MacBook Air 15 M4|S/2900|MacBook Air 15 M4|90-120 min|disponible
    Bateria MacBook Air 15 M4|S/950|MacBook Air 15 M4|60-80 min|disponible
    Teclado MacBook Air 15 M4|S/760|MacBook Air 15 M4|60-90 min|disponible
    Trackpad MacBook Air 15 M4|S/635|MacBook Air 15 M4|45-70 min|disponible
    Puerto MagSafe 3 MacBook Air 15 M4|S/465|MacBook Air 15 M4|50-70 min|disponible
    Tapa Superior MacBook Air 15 M4|S/1120|MacBook Air 15 M4|90-130 min|disponible
    Pantalla MacBook Pro 14 M1 Pro|S/3200|MacBook Pro 14 M1 Pro|90-120 min|disponible
    Bateria MacBook Pro 14 M1 Pro|S/950|MacBook Pro 14 M1 Pro|60-80 min|disponible
    Teclado MacBook Pro 14 M1 Pro|S/780|MacBook Pro 14 M1 Pro|60-90 min|disponible
    Trackpad MacBook Pro 14 M1 Pro|S/640|MacBook Pro 14 M1 Pro|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 14 M1 Pro|S/480|MacBook Pro 14 M1 Pro|50-70 min|disponible
    Tapa Superior MacBook Pro 14 M1 Pro|S/1350|MacBook Pro 14 M1 Pro|90-130 min|disponible
    Pantalla MacBook Pro 16 M1 Max|S/4200|MacBook Pro 16 M1 Max|90-120 min|disponible
    Bateria MacBook Pro 16 M1 Max|S/1100|MacBook Pro 16 M1 Max|60-80 min|disponible
    Teclado MacBook Pro 16 M1 Max|S/900|MacBook Pro 16 M1 Max|60-90 min|disponible
    Trackpad MacBook Pro 16 M1 Max|S/740|MacBook Pro 16 M1 Max|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 16 M1 Max|S/560|MacBook Pro 16 M1 Max|50-70 min|disponible
    Tapa Superior MacBook Pro 16 M1 Max|S/1700|MacBook Pro 16 M1 Max|90-130 min|disponible
    Pantalla MacBook Pro 14 M3 Pro|S/3450|MacBook Pro 14 M3 Pro|90-120 min|disponible
    Bateria MacBook Pro 14 M3 Pro|S/1000|MacBook Pro 14 M3 Pro|60-80 min|disponible
    Teclado MacBook Pro 14 M3 Pro|S/820|MacBook Pro 14 M3 Pro|60-90 min|disponible
    Trackpad MacBook Pro 14 M3 Pro|S/678|MacBook Pro 14 M3 Pro|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 14 M3 Pro|S/510|MacBook Pro 14 M3 Pro|50-70 min|disponible
    Tapa Superior MacBook Pro 14 M3 Pro|S/1420|MacBook Pro 14 M3 Pro|90-130 min|disponible
    Pantalla MacBook Pro 16 M3 Max|S/4600|MacBook Pro 16 M3 Max|90-120 min|disponible
    Bateria MacBook Pro 16 M3 Max|S/1180|MacBook Pro 16 M3 Max|60-80 min|disponible
    Teclado MacBook Pro 16 M3 Max|S/950|MacBook Pro 16 M3 Max|60-90 min|disponible
    Trackpad MacBook Pro 16 M3 Max|S/780|MacBook Pro 16 M3 Max|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 16 M3 Max|S/590|MacBook Pro 16 M3 Max|50-70 min|disponible
    Tapa Superior MacBook Pro 16 M3 Max|S/1820|MacBook Pro 16 M3 Max|90-130 min|disponible
    Pantalla MacBook Pro 14 M4 Pro|S/3700|MacBook Pro 14 M4 Pro|90-120 min|disponible
    Bateria MacBook Pro 14 M4 Pro|S/1050|MacBook Pro 14 M4 Pro|60-80 min|disponible
    Teclado MacBook Pro 14 M4 Pro|S/858|MacBook Pro 14 M4 Pro|60-90 min|disponible
    Trackpad MacBook Pro 14 M4 Pro|S/710|MacBook Pro 14 M4 Pro|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 14 M4 Pro|S/535|MacBook Pro 14 M4 Pro|50-70 min|disponible
    Tapa Superior MacBook Pro 14 M4 Pro|S/1490|MacBook Pro 14 M4 Pro|90-130 min|disponible
    Pantalla MacBook Pro 16 M4 Pro|S/5000|MacBook Pro 16 M4 Pro|90-120 min|disponible
    Bateria MacBook Pro 16 M4 Pro|S/1250|MacBook Pro 16 M4 Pro|60-80 min|disponible
    Teclado MacBook Pro 16 M4 Pro|S/998|MacBook Pro 16 M4 Pro|60-90 min|disponible
    Trackpad MacBook Pro 16 M4 Pro|S/820|MacBook Pro 16 M4 Pro|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 16 M4 Pro|S/618|MacBook Pro 16 M4 Pro|50-70 min|disponible
    Tapa Superior MacBook Pro 16 M4 Pro|S/1920|MacBook Pro 16 M4 Pro|90-130 min|disponible
    Pantalla MacBook Pro 14 M5|S/4000|MacBook Pro 14 M5|90-120 min|disponible
    Bateria MacBook Pro 14 M5|S/1120|MacBook Pro 14 M5|60-80 min|disponible
    Teclado MacBook Pro 14 M5|S/910|MacBook Pro 14 M5|60-90 min|disponible
    Trackpad MacBook Pro 14 M5|S/750|MacBook Pro 14 M5|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 14 M5|S/565|MacBook Pro 14 M5|50-70 min|disponible
    Tapa Superior MacBook Pro 14 M5|S/1570|MacBook Pro 14 M5|90-130 min|disponible
    Pantalla MacBook Pro 16 M5|S/5400|MacBook Pro 16 M5|90-120 min|disponible
    Bateria MacBook Pro 16 M5|S/1320|MacBook Pro 16 M5|60-80 min|disponible
    Teclado MacBook Pro 16 M5|S/1060|MacBook Pro 16 M5|60-90 min|disponible
    Trackpad MacBook Pro 16 M5|S/868|MacBook Pro 16 M5|45-70 min|disponible
    Puerto MagSafe 3 MacBook Pro 16 M5|S/652|MacBook Pro 16 M5|50-70 min|disponible
    Tapa Superior MacBook Pro 16 M5|S/2050|MacBook Pro 16 M5|90-130 min|disponible
    Pantalla iMac 24 M3|S/4500|iMac 24 M3|120-150 min|disponible
    Fuente de Poder iMac 24 M3|S/1100|iMac 24 M3|60-90 min|disponible
    Teclado Magic iMac 24 M3|S/750|iMac 24 M3|15-20 min|disponible
    Magic Trackpad iMac 24 M3|S/620|iMac 24 M3|15-20 min|disponible
    Puerto Thunderbolt iMac 24 M3|S/480|iMac 24 M3|90-120 min|disponible
    Fuente de Poder Mac mini M1|S/800|Mac mini M1|45-60 min|disponible
    Placa Logica Mac mini M1|S/580|Mac mini M1|90-120 min|disponible
    Puerto Thunderbolt Mac mini M1|S/420|Mac mini M1|60-80 min|disponible
    Fuente de Poder Mac mini M2|S/880|Mac mini M2|45-60 min|disponible
    Placa Logica Mac mini M2|S/620|Mac mini M2|90-120 min|disponible
    Puerto Thunderbolt Mac mini M2|S/450|Mac mini M2|60-80 min|disponible
    Fuente de Poder Mac mini M4|S/960|Mac mini M4|45-60 min|disponible
    Placa Logica Mac mini M4|S/665|Mac mini M4|90-120 min|disponible
    Puerto Thunderbolt Mac mini M4|S/480|Mac mini M4|60-80 min|disponible
    Fuente de Poder Mac mini M4 Pro|S/1050|Mac mini M4 Pro|45-60 min|disponible
    Placa Logica Mac mini M4 Pro|S/720|Mac mini M4 Pro|90-120 min|disponible
    Puerto Thunderbolt Mac mini M4 Pro|S/520|Mac mini M4 Pro|60-80 min|disponible
    Fuente de Poder Mac Studio M4 Max|S/1800|Mac Studio M4 Max|60-90 min|disponible
    Placa Logica Mac Studio M4 Max|S/2200|Mac Studio M4 Max|120-180 min|disponible
    Puerto Thunderbolt Mac Studio M4 Max|S/900|Mac Studio M4 Max|60-90 min|disponible
    Fuente de Poder Mac Pro M4 Ultra|S/3500|Mac Pro M4 Ultra|60-90 min|disponible
    Placa Logica Mac Pro M4 Ultra|S/5000|Mac Pro M4 Ultra|120-180 min|disponible
    Puerto Thunderbolt Mac Pro M4 Ultra|S/1400|Mac Pro M4 Ultra|60-90 min|disponible
    Pantalla Apple Watch Series 6|S/600|Apple Watch Series 6|45-60 min|disponible
    Bateria Apple Watch Series 6|S/280|Apple Watch Series 6|30-45 min|disponible
    Corona Digital Apple Watch Series 6|S/300|Apple Watch Series 6|40-55 min|disponible
    Sensor Trasero Apple Watch Series 6|S/320|Apple Watch Series 6|40-55 min|disponible
    Pantalla Apple Watch SE 1|S/520|Apple Watch SE 1|45-60 min|disponible
    Bateria Apple Watch SE 1|S/250|Apple Watch SE 1|30-45 min|disponible
    Corona Digital Apple Watch SE 1|S/268|Apple Watch SE 1|40-55 min|disponible
    Sensor Trasero Apple Watch SE 1|S/288|Apple Watch SE 1|40-55 min|disponible
    Pantalla Apple Watch Series 7|S/640|Apple Watch Series 7|45-60 min|disponible
    Bateria Apple Watch Series 7|S/295|Apple Watch Series 7|30-45 min|disponible
    Corona Digital Apple Watch Series 7|S/315|Apple Watch Series 7|40-55 min|disponible
    Sensor Trasero Apple Watch Series 7|S/335|Apple Watch Series 7|40-55 min|disponible
    Pantalla Apple Watch Series 8|S/680|Apple Watch Series 8|45-60 min|disponible
    Bateria Apple Watch Series 8|S/315|Apple Watch Series 8|30-45 min|disponible
    Corona Digital Apple Watch Series 8|S/335|Apple Watch Series 8|40-55 min|disponible
    Sensor Trasero Apple Watch Series 8|S/355|Apple Watch Series 8|40-55 min|disponible
    Pantalla Apple Watch SE 2|S/560|Apple Watch SE 2|45-60 min|disponible
    Bateria Apple Watch SE 2|S/262|Apple Watch SE 2|30-45 min|disponible
    Corona Digital Apple Watch SE 2|S/280|Apple Watch SE 2|40-55 min|disponible
    Sensor Trasero Apple Watch SE 2|S/300|Apple Watch SE 2|40-55 min|disponible
    Pantalla Apple Watch Nike Series 8|S/695|Apple Watch Nike Series 8|45-60 min|disponible
    Bateria Apple Watch Nike Series 8|S/320|Apple Watch Nike Series 8|30-45 min|disponible
    Corona Digital Apple Watch Nike Series 8|S/340|Apple Watch Nike Series 8|40-55 min|disponible
    Sensor Trasero Apple Watch Nike Series 8|S/360|Apple Watch Nike Series 8|40-55 min|disponible
    Pantalla Apple Watch Hermes Series 8|S/730|Apple Watch Hermes Series 8|45-60 min|disponible
    Bateria Apple Watch Hermes Series 8|S/340|Apple Watch Hermes Series 8|30-45 min|disponible
    Corona Digital Apple Watch Hermes Series 8|S/360|Apple Watch Hermes Series 8|40-55 min|disponible
    Sensor Trasero Apple Watch Hermes Series 8|S/380|Apple Watch Hermes Series 8|40-55 min|disponible
    Pantalla Apple Watch Series 9|S/720|Apple Watch Series 9|45-60 min|disponible
    Bateria Apple Watch Series 9|S/332|Apple Watch Series 9|30-45 min|disponible
    Corona Digital Apple Watch Series 9|S/352|Apple Watch Series 9|40-55 min|disponible
    Sensor Trasero Apple Watch Series 9|S/372|Apple Watch Series 9|40-55 min|disponible
    Pantalla Apple Watch Nike Series 9|S/738|Apple Watch Nike Series 9|45-60 min|disponible
    Bateria Apple Watch Nike Series 9|S/338|Apple Watch Nike Series 9|30-45 min|disponible
    Corona Digital Apple Watch Nike Series 9|S/358|Apple Watch Nike Series 9|40-55 min|disponible
    Sensor Trasero Apple Watch Nike Series 9|S/378|Apple Watch Nike Series 9|40-55 min|disponible
    Pantalla Apple Watch Hermes Series 9|S/780|Apple Watch Hermes Series 9|45-60 min|disponible
    Bateria Apple Watch Hermes Series 9|S/358|Apple Watch Hermes Series 9|30-45 min|disponible
    Corona Digital Apple Watch Hermes Series 9|S/378|Apple Watch Hermes Series 9|40-55 min|disponible
    Sensor Trasero Apple Watch Hermes Series 9|S/398|Apple Watch Hermes Series 9|40-55 min|disponible
    Pantalla Apple Watch Ultra 2|S/1100|Apple Watch Ultra 2|45-60 min|disponible
    Bateria Apple Watch Ultra 2|S/520|Apple Watch Ultra 2|30-45 min|disponible
    Corona Digital Apple Watch Ultra 2|S/560|Apple Watch Ultra 2|40-55 min|disponible
    Sensor Trasero Apple Watch Ultra 2|S/580|Apple Watch Ultra 2|40-55 min|disponible
    Pantalla Apple Watch Series 10|S/760|Apple Watch Series 10|45-60 min|disponible
    Bateria Apple Watch Series 10|S/348|Apple Watch Series 10|30-45 min|disponible
    Corona Digital Apple Watch Series 10|S/368|Apple Watch Series 10|40-55 min|disponible
    Sensor Trasero Apple Watch Series 10|S/388|Apple Watch Series 10|40-55 min|disponible
    Pantalla Apple Watch SE 3|S/600|Apple Watch SE 3|45-60 min|disponible
    Bateria Apple Watch SE 3|S/278|Apple Watch SE 3|30-45 min|disponible
    Corona Digital Apple Watch SE 3|S/298|Apple Watch SE 3|40-55 min|disponible
    Sensor Trasero Apple Watch SE 3|S/318|Apple Watch SE 3|40-55 min|disponible
    Pantalla Apple Watch Series 11|S/800|Apple Watch Series 11|45-60 min|disponible
    Bateria Apple Watch Series 11|S/365|Apple Watch Series 11|30-45 min|disponible
    Corona Digital Apple Watch Series 11|S/385|Apple Watch Series 11|40-55 min|disponible
    Sensor Trasero Apple Watch Series 11|S/405|Apple Watch Series 11|40-55 min|disponible
    Pantalla Apple Watch Ultra 3|S/1200|Apple Watch Ultra 3|45-60 min|disponible
    Bateria Apple Watch Ultra 3|S/560|Apple Watch Ultra 3|30-45 min|disponible
    Corona Digital Apple Watch Ultra 3|S/600|Apple Watch Ultra 3|40-55 min|disponible
    Sensor Trasero Apple Watch Ultra 3|S/620|Apple Watch Ultra 3|40-55 min|disponible
    Auricular Izquierdo AirPods 2a Gen|S/250|AirPods 2a Gen|20-30 min|disponible
    Auricular Derecho AirPods 2a Gen|S/250|AirPods 2a Gen|20-30 min|disponible
    Case de Carga AirPods 2a Gen|S/180|AirPods 2a Gen|15-25 min|disponible
    Almohadillas de Silicona AirPods 2a Gen|S/80|AirPods 2a Gen|5-10 min|disponible
    Auricular Izquierdo AirPods 3a Gen|S/280|AirPods 3a Gen|20-30 min|disponible
    Auricular Derecho AirPods 3a Gen|S/280|AirPods 3a Gen|20-30 min|disponible
    Case de Carga AirPods 3a Gen|S/200|AirPods 3a Gen|15-25 min|disponible
    Almohadillas de Silicona AirPods 3a Gen|S/90|AirPods 3a Gen|5-10 min|disponible
    Auricular Izquierdo AirPods Pro 1a Gen|S/320|AirPods Pro 1a Gen|20-30 min|disponible
    Auricular Derecho AirPods Pro 1a Gen|S/320|AirPods Pro 1a Gen|20-30 min|disponible
    Case de Carga AirPods Pro 1a Gen|S/230|AirPods Pro 1a Gen|15-25 min|disponible
    Almohadillas de Silicona AirPods Pro 1a Gen|S/100|AirPods Pro 1a Gen|5-10 min|disponible
    Auricular Izquierdo AirPods Pro 2 Lightning|S/370|AirPods Pro 2 Lightning|20-30 min|disponible
    Auricular Derecho AirPods Pro 2 Lightning|S/370|AirPods Pro 2 Lightning|20-30 min|disponible
    Case de Carga AirPods Pro 2 Lightning|S/268|AirPods Pro 2 Lightning|15-25 min|disponible
    Almohadillas de Silicona AirPods Pro 2 Lightning|S/115|AirPods Pro 2 Lightning|5-10 min|disponible
    Auricular Izquierdo AirPods Pro 2 USB-C|S/360|AirPods Pro 2 USB-C|20-30 min|disponible
    Auricular Derecho AirPods Pro 2 USB-C|S/360|AirPods Pro 2 USB-C|20-30 min|disponible
    Case de Carga AirPods Pro 2 USB-C|S/260|AirPods Pro 2 USB-C|15-25 min|disponible
    Almohadillas de Silicona AirPods Pro 2 USB-C|S/112|AirPods Pro 2 USB-C|5-10 min|disponible
    Auricular Izquierdo AirPods Pro 3|S/390|AirPods Pro 3|20-30 min|disponible
    Auricular Derecho AirPods Pro 3|S/390|AirPods Pro 3|20-30 min|disponible
    Case de Carga AirPods Pro 3|S/280|AirPods Pro 3|15-25 min|disponible
    Almohadillas de Silicona AirPods Pro 3|S/120|AirPods Pro 3|5-10 min|disponible
    Auricular Izquierdo AirPods 4|S/290|AirPods 4|20-30 min|disponible
    Auricular Derecho AirPods 4|S/290|AirPods 4|20-30 min|disponible
    Case de Carga AirPods 4|S/210|AirPods 4|15-25 min|disponible
    Almohadillas de Silicona AirPods 4|S/95|AirPods 4|5-10 min|disponible
    Auricular Izquierdo AirPods 4 con ANC|S/330|AirPods 4 con ANC|20-30 min|disponible
    Auricular Derecho AirPods 4 con ANC|S/330|AirPods 4 con ANC|20-30 min|disponible
    Case de Carga AirPods 4 con ANC|S/238|AirPods 4 con ANC|15-25 min|disponible
    Almohadillas de Silicona AirPods 4 con ANC|S/102|AirPods 4 con ANC|5-10 min|disponible
    Auricular Izquierdo AirPods Max (Lightning)|S/1150|AirPods Max (Lightning)|40-55 min|disponible
    Auricular Derecho AirPods Max (Lightning)|S/1150|AirPods Max (Lightning)|40-55 min|disponible
    Diadema AirPods Max (Lightning)|S/600|AirPods Max (Lightning)|20-30 min|disponible
    Almohadillas AirPods Max (Lightning)|S/420|AirPods Max (Lightning)|10-15 min|disponible
    Auricular Izquierdo AirPods Max USB-C|S/1250|AirPods Max USB-C|40-55 min|disponible
    Auricular Derecho AirPods Max USB-C|S/1250|AirPods Max USB-C|40-55 min|disponible
    Diadema AirPods Max USB-C|S/650|AirPods Max USB-C|20-30 min|disponible
    Almohadillas AirPods Max USB-C|S/450|AirPods Max USB-C|10-15 min|disponible
    """

    // MARK: - Catálogo real de productos de la tienda (124 productos, 7 categorías)
    private let productCatalog = """
    --- iPhone ---
    iPhone 17e|S/2199|almacenamiento: 128GB/256GB|3 colores disponibles
    iPhone 17 Pro Max|S/4999|almacenamiento: 256GB/512GB/1TB|4 colores disponibles
    iPhone 17 Pro|S/4499|almacenamiento: 128GB/256GB/512GB/1TB|4 colores disponibles
    iPhone Air|S/4199|almacenamiento: 256GB/512GB|4 colores disponibles
    iPhone 17|S/3199|almacenamiento: 128GB/256GB/512GB|5 colores disponibles
    iPhone 16 Pro Max|S/4700|almacenamiento: 256GB/512GB/1TB|4 colores disponibles
    iPhone 16 Pro|S/4199|almacenamiento: 128GB/256GB/512GB/1TB|4 colores disponibles
    iPhone 16 Plus|S/3899|almacenamiento: 128GB/256GB/512GB|5 colores disponibles
    iPhone 16|S/2900|almacenamiento: 128GB/256GB/512GB|5 colores disponibles
    iPhone 16e|S/2119|almacenamiento: 128GB/256GB/512GB|2 colores disponibles
    iPhone 15 Pro Max|S/4283|almacenamiento: 256GB/512GB/1TB|4 colores disponibles
    iPhone 15 Pro|S/3400|almacenamiento: 128GB/256GB/512GB/1TB|4 colores disponibles
    iPhone 15 Plus|S/3200|almacenamiento: 128GB/256GB/512GB|5 colores disponibles
    iPhone 15|S/2600|almacenamiento: 128GB/256GB/512GB|5 colores disponibles
    iPhone 14 Pro Max|S/3300|almacenamiento: 128GB/256GB/512GB/1TB|4 colores disponibles
    iPhone 14 Pro|S/2300|almacenamiento: 128GB/256GB/512GB/1TB|4 colores disponibles
    iPhone 14 Plus|S/2500|almacenamiento: 128GB/256GB/512GB|6 colores disponibles
    iPhone 14|S/2200|almacenamiento: 128GB/256GB/512GB|6 colores disponibles
    iPhone 13 Pro Max|S/2900|almacenamiento: 128GB/256GB/512GB/1TB|5 colores disponibles
    iPhone 13 Pro|S/2100|almacenamiento: 128GB/256GB/512GB/1TB|5 colores disponibles
    iPhone 13|S/1750|almacenamiento: 128GB/256GB/512GB|6 colores disponibles
    iPhone 13 Mini|S/1300|almacenamiento: 128GB/256GB/512GB|6 colores disponibles
    iPhone SE (3ª Gen)|S/1400|almacenamiento: 64GB/128GB/256GB|3 colores disponibles
    iPhone 12 Pro Max|S/2675|almacenamiento: 128GB/256GB/512GB|4 colores disponibles
    iPhone 12 Pro|S/1900|almacenamiento: 128GB/256GB/512GB|4 colores disponibles
    iPhone 12|S/1499|almacenamiento: 64GB/128GB/256GB|6 colores disponibles
    
    --- iPad ---
    iPad Pro 13" M4|S/6963|almacenamiento: 256GB/512GB/1TB/2TB|2 colores disponibles
    iPad Pro 11" M4|S/5355|almacenamiento: 256GB/512GB/1TB/2TB|2 colores disponibles
    iPad Air 11" M2|S/3950|almacenamiento: 128GB/256GB/512GB/1TB|4 colores disponibles
    iPad Air 13" M2|S/4150|almacenamiento: 128GB/256GB/512GB/1TB|3 colores disponibles
    iPad mini 7|S/2675|almacenamiento: 128GB/256GB/512GB|4 colores disponibles
    iPad Pro 12.9" M2|S/5087|almacenamiento: 128GB/256GB/512GB/1TB/2TB|2 colores disponibles
    iPad Pro 11" M2|S/4699|almacenamiento: 128GB/256GB/512GB/1TB/2TB|2 colores disponibles
    iPad 10ª Gen|S/1871|almacenamiento: 64GB/256GB|4 colores disponibles
    iPad 9ª Gen|S/1495|almacenamiento: 64GB/256GB|2 colores disponibles
    iPad mini 6|S/2407|almacenamiento: 64GB/256GB|4 colores disponibles
    iPad Pro 12.9" M1|S/4283|almacenamiento: 128GB/256GB/512GB/1TB/2TB|2 colores disponibles
    iPad Air 5ª Gen (M1)|S/3091|almacenamiento: 64GB/256GB|5 colores disponibles
    iPad Air 4ª Gen|S/2451|almacenamiento: 64GB/256GB|5 colores disponibles
    iPad mini 5ª Gen|S/1703|almacenamiento: 64GB/256GB|4 colores disponibles
    iPad 8ª Gen|S/1275|almacenamiento: 32GB/128GB|3 colores disponibles
    iPad 7ª Gen|S/1059|almacenamiento: 32GB/128GB|3 colores disponibles
    iPad Air 3ª Gen|S/1811|almacenamiento: 64GB/256GB|5 colores disponibles
    
    --- Mac ---
    MacBook Pro 16" M5|S/18755|almacenamiento: 512GB/1TB/2TB/4TB|2 colores disponibles
    MacBook Pro 14" M5|S/13395|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    MacBook Air 15" M4|S/7500|almacenamiento: 256GB/512GB/1TB/2TB|4 colores disponibles
    MacBook Air 13" M4|S/6500|almacenamiento: 256GB/512GB/1TB/2TB|4 colores disponibles
    MacBook Pro 16" M4 Pro|S/17500|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    MacBook Pro 14" M4 Pro|S/10715|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    Mac mini M4 Pro|S/4819|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    Mac mini M4|S/3747|almacenamiento: 256GB/512GB|1 colores disponibles
    Mac Studio M4 Max|S/21435|almacenamiento: 512GB/1TB/2TB|1 colores disponibles
    Mac Pro M4 Ultra|S/42876|almacenamiento: 1TB/2TB/4TB/8TB|1 colores disponibles
    iMac 24" M3|S/6963|almacenamiento: 256GB/512GB/1TB/2TB|7 colores disponibles
    MacBook Pro 16" M3 Max|S/16075|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    MacBook Pro 14" M3 Pro|S/9500|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    MacBook Air 15" M3|S/6963|almacenamiento: 256GB/512GB/1TB/2TB|4 colores disponibles
    MacBook Air 13" M3|S/5891|almacenamiento: 256GB/512GB/1TB/2TB|4 colores disponibles
    MacBook Air 13" M2|S/5355|almacenamiento: 256GB/512GB/1TB/2TB|4 colores disponibles
    MacBook Pro 14" M1 Pro|S/8571|almacenamiento: 512GB/1TB/2TB|2 colores disponibles
    MacBook Pro 16" M1 Max|S/13395|almacenamiento: 1TB/2TB/4TB|2 colores disponibles
    Mac mini M2|S/3211|almacenamiento: 256GB/512GB/1TB/2TB|1 colores disponibles
    Mac mini M1|S/2900|almacenamiento: 256GB/512GB/1TB/2TB|1 colores disponibles
    
    --- Apple Watch ---
    Apple Watch Series 11|S/2350|almacenamiento: N/A|4 colores disponibles
    Apple Watch Ultra 3|S/4600|almacenamiento: N/A|1 colores disponibles
    Apple Watch SE 3|S/1450|almacenamiento: N/A|3 colores disponibles
    Apple Watch Series 10|S/2139|almacenamiento: N/A|3 colores disponibles
    Apple Watch Ultra 2|S/4283|almacenamiento: N/A|1 colores disponibles
    Apple Watch Series 9|S/1950|almacenamiento: N/A|5 colores disponibles
    Apple Watch SE 2|S/1335|almacenamiento: N/A|3 colores disponibles
    Apple Watch Series 8|S/1800|almacenamiento: N/A|4 colores disponibles
    Apple Watch Series 7|S/1650|almacenamiento: N/A|5 colores disponibles
    Apple Watch SE 1|S/1200|almacenamiento: N/A|3 colores disponibles
    Apple Watch Series 6|S/1500|almacenamiento: N/A|5 colores disponibles
    Apple Watch Hermès Series 9|S/4819|almacenamiento: N/A|1 colores disponibles
    Apple Watch Nike Series 9|S/2040|almacenamiento: N/A|2 colores disponibles
    Apple Watch Nike Series 8|S/1875|almacenamiento: N/A|2 colores disponibles
    Apple Watch Hermès Series 8|S/4283|almacenamiento: N/A|1 colores disponibles
    
    --- AirPods ---
    AirPods Pro 3|S/1335|almacenamiento: N/A|1 colores disponibles
    AirPods Pro 2 USB-C|S/1227|almacenamiento: N/A|1 colores disponibles
    AirPods Pro 2 Lightning|S/1335|almacenamiento: N/A|1 colores disponibles
    AirPods Max USB-C|S/2943|almacenamiento: N/A|5 colores disponibles
    AirPods Max (Lightning)|S/2675|almacenamiento: N/A|5 colores disponibles
    AirPods 4 con ANC|S/959|almacenamiento: N/A|1 colores disponibles
    AirPods 4|S/691|almacenamiento: N/A|1 colores disponibles
    AirPods 3ª Gen|S/691|almacenamiento: N/A|1 colores disponibles
    AirPods 2ª Gen|S/531|almacenamiento: N/A|1 colores disponibles
    AirPods Pro 1ª Gen|S/959|almacenamiento: N/A|1 colores disponibles
    
    --- TV y Casa ---
    Apple TV 4K (2024) WiFi|S/531|almacenamiento: N/A|0 colores disponibles
    Apple TV 4K (2024) Wi-Fi + Ethernet|S/638|almacenamiento: N/A|0 colores disponibles
    Apple TV HD|S/316|almacenamiento: N/A|0 colores disponibles
    Apple TV 4K (2022)|S/531|almacenamiento: N/A|0 colores disponibles
    HomePod 2ª Gen|S/1603|almacenamiento: N/A|0 colores disponibles
    HomePod mini Blanco|S/531|almacenamiento: N/A|0 colores disponibles
    HomePod mini Medianoche|S/531|almacenamiento: N/A|0 colores disponibles
    HomePod mini Naranja|S/531|almacenamiento: N/A|0 colores disponibles
    HomePod mini Amarillo|S/531|almacenamiento: N/A|0 colores disponibles
    HomePod mini Azul|S/531|almacenamiento: N/A|0 colores disponibles
    HomePod mini Rojo|S/531|almacenamiento: N/A|0 colores disponibles
    
    --- Accesorios ---
    Magic Keyboard con Touch ID USB-C|S/1067|almacenamiento: N/A|2 colores disponibles
    Magic Keyboard Numérico USB-C|S/1335|almacenamiento: N/A|2 colores disponibles
    Magic Mouse USB-C|S/531|almacenamiento: N/A|2 colores disponibles
    Magic Trackpad USB-C|S/691|almacenamiento: N/A|2 colores disponibles
    Apple Pencil Pro|S/691|almacenamiento: N/A|1 colores disponibles
    Apple Pencil 2ª Gen|S/691|almacenamiento: N/A|1 colores disponibles
    Apple Pencil USB-C|S/423|almacenamiento: N/A|1 colores disponibles
    Apple Pencil 1ª Gen|S/531|almacenamiento: N/A|1 colores disponibles
    Magic Keyboard para iPad Pro M4 13"|S/1871|almacenamiento: N/A|2 colores disponibles
    Magic Keyboard para iPad Pro M4 11"|S/1603|almacenamiento: N/A|2 colores disponibles
    Magic Keyboard Folio iPad 10ª Gen|S/1067|almacenamiento: N/A|1 colores disponibles
    Smart Keyboard para iPad 9ª Gen|S/638|almacenamiento: N/A|1 colores disponibles
    AirTag|S/155|almacenamiento: N/A|0 colores disponibles
    AirTag 4 Pack|S/531|almacenamiento: N/A|0 colores disponibles
    Cable USB-C a USB-C 1m|S/102|almacenamiento: N/A|0 colores disponibles
    Cable USB-C a Lightning 1m|S/102|almacenamiento: N/A|0 colores disponibles
    Cable Thunderbolt 4 Pro 1m|S/263|almacenamiento: N/A|0 colores disponibles
    Adaptador Lightning a 3.5mm|S/48|almacenamiento: N/A|0 colores disponibles
    Adaptador USB-C Multipuerto|S/423|almacenamiento: N/A|0 colores disponibles
    Cargador USB-C 20W|S/155|almacenamiento: N/A|0 colores disponibles
    Cargador USB-C 30W|S/263|almacenamiento: N/A|0 colores disponibles
    Cargador USB-C 67W|S/531|almacenamiento: N/A|0 colores disponibles
    Base MagSafe Duo|S/852|almacenamiento: N/A|0 colores disponibles
    Funda FineWoven iPhone 17 Pro Max|S/316|almacenamiento: N/A|4 colores disponibles
    Funda Silicona iPhone 17|S/263|almacenamiento: N/A|5 colores disponibles
    """

    // MARK: - System Prompt: asistente unificado (soporte técnico + asesor de compra)
    private var systemPrompt: String {
        """
        Eres el asistente virtual de la tienda: cumples dos roles en una sola conversación,
        sin que el cliente tenga que elegir uno. Por un lado eres técnico certificado del
        Servicio Técnico Apple (reparaciones y repuestos). Por otro, eres asesor de ventas
        que recomienda productos Apple reales del catálogo de la tienda según lo que el
        cliente necesita. Tu tono es profesional, cercano y con experiencia real — nunca
        menciones que eres una IA, un modelo de lenguaje, un chatbot, ni que este es un
        proyecto académico o de tesis. Preséntate únicamente como parte del equipo de la
        tienda.

        DATOS DE CONTACTO REALES DE LA TIENDA (usa estos exactos si el cliente pide hablar
        con una persona, llamar, o si tú mismo ofreces una vía alterna de contacto — nunca
        inventes otro número ni correo):
        - Teléfono / WhatsApp: +51 951 012 633
        - Correo: soporte@tech.com
        - Horario de atención: Lunes a Viernes, 9:00 a 18:00

        ============================================================
        CATÁLOGO REAL DE REPUESTOS (única fuente de verdad para reparaciones — precios,
        modelos compatibles, tiempos y disponibilidad). NUNCA inventes un repuesto que no
        esté aquí; si no lo encuentras, dilo con honestidad y ofrece contactar al equipo por
        WhatsApp o teléfono al número de arriba para confirmar:

        \(repairCatalog)

        ============================================================
        CATÁLOGO REAL DE PRODUCTOS EN VENTA (única fuente de verdad para recomendaciones de
        compra — nombre, precio base, almacenamiento y colores disponibles). NUNCA inventes
        un producto, precio o especificación que no esté aquí:

        \(productCatalog)

        ============================================================
        CÓMO RECOMENDAR PRODUCTOS SEGÚN EL PERFIL DEL CLIENTE:
        Cuando el cliente pida una recomendación de compra (ej. "qué iPhone me recomiendas",
        "quiero una laptop", "qué me conviene"), identifica o pregunta brevemente para qué lo
        va a usar, y adapta la sugerencia a un perfil típico:
        - Estudiante: prioriza buena relación precio-rendimiento, almacenamiento medio
          (128-256GB), evita el tope de gama salvo que lo pida explícitamente.
        - Profesor / oficina / uso básico: prioriza simplicidad, batería y precio accesible;
          no recomiendas gama Pro salvo que el uso lo justifique.
        - Profesional creativo / diseñador / editor de video: prioriza pantalla grande,
          más almacenamiento (512GB+) y los modelos Pro/Pro Max o Mac con más rendimiento.
        - Gamer / uso intensivo: prioriza el chip más potente disponible, buena pantalla
          (ProMotion si aplica) y almacenamiento amplio.
        - Si el cliente no da pistas de uso, pregúntale en una sola frase corta antes de
          recomendar (ej. "¿Lo usarás más para trabajo, estudio, diseño o algo casual?").
        No asumas un perfil sin evidencia ni lo inventes si el cliente ya lo dijo explícito.
        Siempre menciona precio y, si aplica, opciones de almacenamiento/color reales del
        catálogo de arriba — nunca cifras aproximadas ni modelos que no existan en él.

        SOBRE QUÉ SÍ PUEDES HABLAR:
        - Diagnóstico básico según los síntomas que describa el cliente (ej. "se apaga solo"
          puede ser batería; "no reconoce mi rostro" puede ser el módulo Face ID).
        - Repuestos, precios (en soles S/), modelos compatibles, tiempos de reparación y
          disponibilidad — SIEMPRE basado en el catálogo de repuestos.
        - Recomendaciones de compra de productos Apple reales del catálogo de productos,
          adaptadas al uso que el cliente le dará.
        - Comparaciones entre modelos del catálogo (precio, almacenamiento, gama).
        - Garantía del servicio técnico y proceso de reparación.
        - Cómo agregar un producto o repuesto al carrito y pagar dentro de la app.
        - Saludos y conversación mínima de bienvenida.

        SOBRE QUÉ NO DEBES HABLAR:
        - Cualquier tema que no sea productos, compras o servicio técnico Apple de la tienda
          (clima, cultura general, otras marcas, temas personales, etc.). Si preguntan algo
          así, redirige con amabilidad hacia productos, compras o reparaciones Apple.

        ESTILO DE RESPUESTA:
        - Texto plano, SIN markdown: nunca uses asteriscos para negrita (**texto**), guiones
          para listas, numerales (#) ni ningún otro símbolo de formato. La app muestra tu
          respuesta como texto normal, así que cualquier símbolo de markdown aparece literal
          en pantalla. Si quieres resaltar algo (precio, nombre de producto), simplemente
          escríbelo tal cual, sin asteriscos ni comillas especiales.
        - Directo, seguro, con lenguaje técnico pero explicado simple.
        - Breve (máximo 3-4 párrafos cortos, o menos si es un saludo).
        - Sin listas largas ni tono de manual; conversacional, como cara a cara en el mostrador.
        - Menciona precios y datos exactos del catálogo correspondiente cuando el cliente
          pregunte por un repuesto o producto específico.
        - Español latino, profesional pero cercano.
        """
    }

    // MARK: - Limpieza de markdown (la burbuja de chat solo muestra texto plano)
    static func stripMarkdown(_ text: String) -> String {
        var result = text
        // Negrita/cursiva: **texto** o *texto* -> texto
        result = result.replacingOccurrences(of: #"\*\*(.*?)\*\*"#, with: "$1", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\*(.*?)\*"#, with: "$1", options: .regularExpression)
        // Encabezados markdown al inicio de línea: "# ", "## ", etc.
        result = result.replacingOccurrences(of: #"(?m)^#{1,6}\s*"#, with: "", options: .regularExpression)
        // Viñetas markdown al inicio de línea: "- " o "* "
        result = result.replacingOccurrences(of: #"(?m)^[\-\*]\s+"#, with: "", options: .regularExpression)
        return result
    }

    // MARK: - Inicializador
    init() {
        loadConversationHistory()
    }

    // MARK: - Chat Conversacional Principal

    /// Enviar mensaje en modo chat (mantiene historial)
    func sendChatMessage(_ userMessage: String) async {
        let userMsg = ChatMessage(role: "user", text: userMessage)
        conversationHistory.append(userMsg)
        saveConversationHistory()

        isLoading = true
        errorMessage = ""
        lastResponse = ""

        guard !apiKey.isEmpty else {
            errorMessage = "Falta configurar la API key de Gemini en GeminiManager.swift"
            isLoading = false
            return
        }

        // Historial reciente en el formato que espera la API de Gemini.
        let recentHistory = conversationHistory
            .dropLast() // el mensaje del usuario ya se agrega aparte abajo
            .suffix(10)

        var contents: [[String: Any]] = recentHistory.map { msg in
            ["role": msg.role, "parts": [["text": msg.text]]]
        }
        contents.append(["role": "user", "parts": [["text": userMessage]]])

        let body: [String: Any] = [
            "contents": contents,
            "systemInstruction": [
                "parts": [["text": systemPrompt]]
            ],
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 2048,
                "topP": 0.95,
                "topK": 40,
                "thinkingConfig": [
                    "thinkingBudget": 0
                ]
            ],
            "safetySettings": [
                ["category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"],
                ["category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"],
                ["category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"],
                ["category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"]
            ]
        ]

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)") else {
            errorMessage = "URL inválida"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Respuesta inválida del servidor"
                isLoading = false
                return
            }

            guard httpResponse.statusCode == 200 else {
                let errText = String(data: data, encoding: .utf8) ?? ""
                print("❌ Error Gemini \(httpResponse.statusCode): \(errText)")
                errorMessage = friendlyMessage(forStatus: httpResponse.statusCode)
                isLoading = false
                return
            }

            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let candidates = json?["candidates"] as? [[String: Any]]
            let content = candidates?.first?["content"] as? [String: Any]
            let parts = content?["parts"] as? [[String: Any]]
            let text = parts?.compactMap { $0["text"] as? String }.joined()

            if let text = text, !text.isEmpty {
                let cleanText = GeminiManager.stripMarkdown(text)
                lastResponse = cleanText
                let modelMsg = ChatMessage(role: "model", text: cleanText)
                conversationHistory.append(modelMsg)
                saveConversationHistory()
            } else {
                errorMessage = "Respuesta vacía del servidor"
            }
        } catch {
            print("❌ Error geminiChat: \(error)")
            errorMessage = "Error de red"
        }

        isLoading = false
    }

    /// Limpiar historial del chat
    func clearConversation() {
        conversationHistory.removeAll()
        saveConversationHistory()
        print("🧹 Historial del chat limpiado")
    }

    // MARK: - Manejo de errores amigable
    private func friendlyMessage(forStatus code: Int) -> String {
        switch code {
        case 400: return "Mensaje inválido"
        case 403: return "API key inválida o sin permisos"
        case 404: return "Modelo no encontrado"
        case 429: return "Demasiadas solicitudes, espera un momento"
        case 500...599: return "Servidor de Gemini no disponible"
        default: return "No se pudo obtener respuesta"
        }
    }

    // MARK: - Persistencia del Historial
    private func saveConversationHistory() {
        if let encoded = try? JSONEncoder().encode(conversationHistory) {
            UserDefaults.standard.set(encoded, forKey: "gemini_conversation_history")
        }
    }

    private func loadConversationHistory() {
        if let data = UserDefaults.standard.data(forKey: "gemini_conversation_history"),
           let decoded = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            conversationHistory = decoded
            print("🔄 Historial cargado: \(conversationHistory.count) mensajes")
        }
    }
}
