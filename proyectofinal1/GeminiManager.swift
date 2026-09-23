import Foundation
import SwiftUI

@MainActor
class GeminiManager: ObservableObject {
    static let shared = GeminiManager()

    @Published var lastResponse = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var streamingText = ""
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

    // 🔑 La API key vive en Secrets.swift
    private let apiKey = Secrets.geminiAPIKey

    // ⚡ MODELOS VÁLIDOS Y ACTUALIZADOS (revisado sep 2026):
    // gemini-flash-latest: alias que Google mantiene apuntando siempre al Flash estable más reciente
    // gemini-3.6-flash: modelo estable fijo, usado como fallback si el alias tiene problemas
    //
    // ⚠️ IMPORTANTE:
    // Los modelos gemini-2.0-flash, gemini-1.5-flash y gemini-2.5-flash ya NO están disponibles para cuentas nuevas (devuelven 404).
    // Google indica explícitamente usar 'gemini-3.6-flash' como reemplazo directo cuando se recibe un 404.
    private let primaryModel = "gemini-flash-latest"
    private let fallbackModel = "gemini-3.6-flash"

    // ✅ URLSession con timeout OPTIMIZADO PARA GEMINI API
    private lazy var urlSession: URLSession = {
        var config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30      // ✅ 30 segundos para requests
        config.timeoutIntervalForResource = 30    // ✅ 30 segundos para transacción completa
        config.waitsForConnectivity = true
        config.httpMaximumConnectionsPerHost = 4
        // ✅ httpShouldUsePipelining REMOVIDO (deprecated en iOS 18.4)
        // URLSession usa HTTP/2 y HTTP/3 automáticamente en iOS moderno
        return URLSession(configuration: config)
    }()

    // Catálogo de repuestos
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
    """

    // Ficha técnica de la generación actual de iPhones
    // (formato: modelo|pantalla y refresco|procesador|cámaras|colores|precio base USD)
    private let iphoneCatalog = """
    iPhone 17|6.3" OLED 120 Hz ProMotion|A19|Dual Fusion 48 MP (principal + gran angular)|Lavanda, Azul Neblina, Salvia, Blanco, Negro|Desde $799 (256 GB)
    iPhone 17 Air|6.5" Ultra-Slim OLED 120 Hz|A19|Principal 48 MP (diseño ultra delgado)|Azul Cielo, Oro Claro, Blanco Nube, Negro Espacial|Desde $999 (256 GB)
    iPhone 18 Pro|6.3" OLED 120 Hz ProMotion|A20 Pro|Triple 48 MP apertura variable f/1.48-f/4.0 + teleobjetivo|Gris Titanio, Plata, Rojo Oscuro|Desde $1,099 (256 GB)
    iPhone 18 Pro Max|6.9" OLED 120 Hz ProMotion|A20 Pro|Triple 48 MP apertura variable + zoom periscópico avanzado|Gris Titanio, Plata, Rojo Oscuro|Desde $1,199 (256 GB)
    iPhone Duo|Plegable 7.6" interno / 5.4" externo|A20 Pro|Cámaras integradas 48 MP con soporte Apple Pencil|Titanio Oscuro, Plata Estelar|Desde $1,799 (256 GB)
    """

    // Especificaciones comunes a toda la línea
    private let iphoneCommonSpecs = """
    - Puerto USB-C en toda la línea (USB 3.2 en versiones Pro y Duo).
    - Chip de conectividad Wi-Fi 7 y Bluetooth 6.0.
    - Hardware optimizado para Apple Intelligence y Siri AI mediante el Neural Engine de última generación.
    """

    private let educationCatalog = """
    MacBook Neo|A18 Pro|13 pulgadas Liquid Retina|hasta 16 horas|desde $599 educativo
    MacBook Air M5|desde $1,199 educativo
    MacBook Pro M5|desde $1,899 educativo
    iPad Air M4|desde $699 educativo
    iPad Pro|desde $1,099 educativo
    Apple Watch Series 12|desde $359 educativo
    Mac mini|desde $799 educativo
    Mac Studio|desde $2,299 educativo
    Apple Watch Ultra 4|desde $719 educativo
    iPad|desde $429 educativo
    iPad mini|desde $549 educativo
    iMac|desde $1,449 educativo
    """

    // Catálogo VIVO de TODOS los productos de la app (se lee del ProductStore en cada consulta)
    private var productCatalog: String {
        let products = ProductStore.shared.products
        guard !products.isEmpty else { return "(sin productos cargados)" }

        // Agrupa por categoría conservando el orden de aparición
        var order: [String] = []
        var grouped: [String: [String]] = [:]
        for product in products {
            let category = product.category.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = category.isEmpty ? "Otros" : category
            if grouped[key] == nil {
                grouped[key] = []
                order.append(key)
            }
            let stockLabel = (product.inStock && product.stock > 0)
                ? "\(product.stock) uds"
                : "agotado"
            grouped[key]?.append("\(product.name)|$\(Int(product.price))|\(stockLabel)")
        }

        return order.map { category in
            let lines = grouped[category] ?? []
            return "【\(category)】 (\(lines.count))\n" + lines.joined(separator: "\n")
        }.joined(separator: "\n\n")
    }

    // MARK: - System Prompt
    private var isEnglish: Bool {
        (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es") == "en"
    }

    private var systemPrompt: String {
        let languageRule = isEnglish
            ? "IMPORTANT: You MUST answer ONLY in ENGLISH. Every word of your reply must be in English, regardless of the language the user writes in."
            : "IMPORTANTE: Debes responder SIEMPRE y SOLO en ESPAÑOL (es-ES o es-MX), sin importar en qué idioma escriba el usuario."

        return """
        \(languageRule)

        Eres el asistente de soporte de nuestra tienda de productos y servicios de reparación Apple.

        TU ROL: Eres amable, conciso, natural y útil. Hablas como una persona real, no como un robot.
        - \(isEnglish ? "You answer in ENGLISH" : "Respondes en ESPAÑOL (es-ES o es-MX)")
        - Ofreces productos de la tienda y servicios de reparación
        - Haces preguntas naturales si necesitas aclaraciones
        - Reconoces intenciones de compra ("quiero", "necesito", "me gustaría")
        - Sugieres categorías o productos de forma orgánica
        - Cuando el usuario quiera comprar o pida una recomendación, menciona el nombre exacto del producto del catálogo para que la app pueda dirigirlo a su ficha de compra.

        REGLA DE ORO - RESPUESTAS REALES Y COMPLETAS:
        - Responde SIEMPRE con los datos concretos de los catálogos de abajo (modelos, pantallas, chips, cámaras, colores y precios).
        - NUNCA inventes modelos, precios, colores ni especificaciones que no estén en los catálogos.
        - Si te preguntan por un modelo, color, precio o ficha técnica que SÍ existe en el catálogo, da el dato exacto y completo.
        - Si algo NO está en el catálogo, dilo con honestidad y ofrece la alternativa más cercana que sí esté.
        - Escribe oraciones completas y cerradas: nunca cortes la respuesta a media frase ni dejes palabras a medias.
        - Sé breve pero completo: máximo 4-6 oraciones.

        CATÁLOGO DE REPARACIONES (formato: pieza|precio|modelo|tiempo|estado):
        \(repairCatalog)

        FICHA TÉCNICA DE iPHONES (formato: modelo|pantalla|chip|cámaras|colores|precio base USD):
        \(iphoneCatalog)

        ESPECIFICACIONES COMUNES DE LA LÍNEA iPHONE:
        \(iphoneCommonSpecs)

        CATÁLOGO DE PRECIOS EDUCATIVOS DE APPLE (us-edu):
        \(educationCatalog)
        Estos precios son orientativos y pueden requerir verificación de estudiante o educador.

        CATÁLOGO COMPLETO DE PRODUCTOS DE LA APP, AGRUPADOS POR CATEGORÍA
        (cada línea es: nombre|precio USD|stock. "agotado" significa sin existencias):
        \(productCatalog)

        Este es el inventario REAL y COMPLETO de la tienda. Cuando te pregunten qué productos hay,
        usa SOLO estos datos: menciona nombres reales con su categoría (iPhone, iPad, Mac,
        Apple Watch, AirPods/Accesorios, TV y Casa) y su precio. Si te piden "todo" o "todos",
        recorre TODAS las categorías citando ejemplos reales con precio. Si un producto dice
        "agotado", indícalo. NUNCA inventes productos, precios ni categorías fuera de esta lista.
        """
    }

    // MARK: - Inicializador
    init() {
        loadConversationHistory()
    }

    // MARK: - Chat Conversacional Principal (VERSIÓN MEJORADA)

    /// Enviar mensaje en modo chat con reintentos inteligentes
    func sendChatMessage(_ userMessage: String) async {
        let userMsg = ChatMessage(role: "user", text: userMessage)
        conversationHistory.append(userMsg)
        saveConversationHistory()

        isLoading = true
        errorMessage = ""
        lastResponse = ""

        guard !apiKey.isEmpty else {
            errorMessage = "⚠️ API key no configurada"
            isLoading = false
            return
        }

        // Historial reciente optimizado
        let recentHistory = conversationHistory
            .dropLast()
            .suffix(4)

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
                "topK": 40
            ],
            "safetySettings": [
                ["category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"],
                ["category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"],
                ["category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"],
                ["category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"]
            ]
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            errorMessage = "Error al serializar datos"
            isLoading = false
            return
        }

        let modelsToTry = [primaryModel, fallbackModel]
        var responseSuccess = false
        var lastError: Error?

        for currentModel in modelsToTry {
            // ✅ REINTENTOS CON BACKOFF EXPONENCIAL
            for attempt in 0..<3 {
                guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(currentModel):generateContent?key=\(apiKey)") else {
                    continue
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = bodyData

                do {
                    print("📤 Intento \(attempt + 1)/3 con modelo: \(currentModel)")
                    
                    let (data, response) = try await urlSession.data(for: request)

                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("❌ Sin respuesta HTTP")
                        continue
                    }

                    print("📊 Status Code: \(httpResponse.statusCode)")

                    // ✅ MANEJO DE RATE LIMITING (429)
                    if httpResponse.statusCode == 429 {
                        let waitTime = Double(attempt + 1) * 2.0 // 2s, 4s, 6s
                        print("⏳ Rate limit. Esperando \(waitTime)s antes de reintentar...")
                        try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
                        continue
                    }

                    guard httpResponse.statusCode == 200 else {
                        // ✅ Log del body para diagnosticar rápido si un modelo vuelve a fallar
                        let bodyText = String(data: data, encoding: .utf8) ?? "(sin body)"
                        print("⚠️ Status \(httpResponse.statusCode) con \(currentModel): \(bodyText)")
                        continue
                    }

                    // ✅ PARSEO DE RESPUESTA
                    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let candidates = json["candidates"] as? [[String: Any]],
                          let content = candidates.first?["content"] as? [String: Any],
                          let parts = content["parts"] as? [[String: Any]] else {
                        print("❌ No se pudo parsear la respuesta")
                        continue
                    }

                    let textArray = parts.compactMap { $0["text"] as? String }
                    let text = textArray.joined()

                    if !text.isEmpty {
                        let cleanText = GeminiManager.stripMarkdown(text)
                        lastResponse = cleanText
                        let modelMsg = ChatMessage(role: "model", text: cleanText)
                        conversationHistory.append(modelMsg)
                        saveConversationHistory()
                        responseSuccess = true
                        print("✅ Respuesta exitosa de \(currentModel)")
                        break
                    }
                } catch let error as URLError {
                    lastError = error
                    print("❌ URLError (\(error.code)): \(error.localizedDescription)")
                    
                    // ✅ BACKOFF EXPONENCIAL EN CASO DE ERROR
                    if attempt < 2 {
                        let waitTime = Double(attempt + 1) * 1.5
                        print("⏳ Esperando \(waitTime)s antes de reintentar...")
                        try? await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
                    }
                    continue
                } catch {
                    lastError = error
                    print("❌ Error: \(error.localizedDescription)")
                    continue
                }
            }

            if responseSuccess {
                break  // ✅ No necesita probar otros modelos
            }
        }

        if !responseSuccess {
            // ✅ RESPUESTA AMIGABLE EN CASO DE FALLO
            let friendlyFallback = isEnglish
                ? "Hi! The connection is slow right now, but I'm still here. Could you try again? 😊"
                : "¡Hola! En este momento hay conexión lenta, pero sigo aquí. ¿Podrías intentar de nuevo? 😊"
            lastResponse = friendlyFallback
            lastError.map { print("📛 Error final: \($0.localizedDescription)") }
            
            let modelMsg = ChatMessage(role: "model", text: friendlyFallback)
            conversationHistory.append(modelMsg)
            saveConversationHistory()
        }

        isLoading = false
    }

    // MARK: - Chat con Streaming (respuesta inmediata)

    /// Igual que sendChatMessage pero entrega el texto por fragmentos apenas llega (SSE).
    /// `onChunk` recibe el texto ACUMULADO hasta el momento, en el MainActor.
    func sendChatMessageStreaming(
        _ userMessage: String,
        onChunk: @escaping @MainActor (String) -> Void
    ) async {
        let userMsg = ChatMessage(role: "user", text: userMessage)
        conversationHistory.append(userMsg)
        saveConversationHistory()

        isLoading = true
        errorMessage = ""
        lastResponse = ""
        streamingText = ""

        guard !apiKey.isEmpty else {
            errorMessage = "⚠️ API key no configurada"
            isLoading = false
            return
        }

        let recentHistory = conversationHistory.dropLast().suffix(4)
        var contents: [[String: Any]] = recentHistory.map { msg in
            ["role": msg.role, "parts": [["text": msg.text]]]
        }
        contents.append(["role": "user", "parts": [["text": userMessage]]])

        let body: [String: Any] = [
            "contents": contents,
            "systemInstruction": ["parts": [["text": systemPrompt]]],
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 2048,
                "topP": 0.95,
                "topK": 40,
                "thinkingConfig": ["thinkingLevel": "LOW"]
            ]
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: body),
              let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(primaryModel):streamGenerateContent?alt=sse&key=\(apiKey)") else {
            errorMessage = "Error al preparar la solicitud"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData

        var accumulated = ""
        do {
            let (bytes, response) = try await urlSession.bytes(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                for try await line in bytes.lines {
                    guard line.hasPrefix("data: ") else { continue }
                    let payload = String(line.dropFirst(6))
                    if payload == "[DONE]" { break }
                    guard let data = payload.data(using: .utf8),
                          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let candidates = json["candidates"] as? [[String: Any]],
                          let content = candidates.first?["content"] as? [String: Any],
                          let parts = content["parts"] as? [[String: Any]] else { continue }
                    let chunk = parts.compactMap { $0["text"] as? String }.joined()
                    if !chunk.isEmpty {
                        accumulated += chunk
                        streamingText = accumulated
                        onChunk(accumulated)
                    }
                }
            }
        } catch {
            print("❌ Streaming error: \(error.localizedDescription)")
        }

        if accumulated.isEmpty {
            // Si el streaming falló, usamos la vía normal como respaldo.
            conversationHistory.removeLast()  // evita duplicar el mensaje de usuario
            await sendChatMessage(userMessage)
            onChunk(lastResponse)
            return
        }

        let clean = GeminiManager.stripMarkdown(accumulated)
        lastResponse = clean
        streamingText = ""
        conversationHistory.append(ChatMessage(role: "model", text: clean))
        saveConversationHistory()
        isLoading = false
    }

    // MARK: - Utilidades
    
    /// Limpiar historial del chat
    func clearConversation() {
        conversationHistory.removeAll()
        saveConversationHistory()
        print("🧹 Historial limpiado")
    }

    /// Remover markdown de la respuesta
    private static func stripMarkdown(_ text: String) -> String {
        var result = text
        // Remover **negrita**
        result = result.replacingOccurrences(of: #"\*\*(.+?)\*\*"#, with: "$1", options: .regularExpression)
        // Remover *itálica*
        result = result.replacingOccurrences(of: #"\*(.+?)\*"#, with: "$1", options: .regularExpression)
        // Remover __subrayado__
        result = result.replacingOccurrences(of: #"__(.+?)__"#, with: "$1", options: .regularExpression)
        // Remover bloques de código
        result = result.replacingOccurrences(of: #"```[\s\S]*?```"#, with: "", options: .regularExpression)
        // Remover listas de puntos
        result = result.replacingOccurrences(of: #"(?m)^\s*[-*+]\s+"#, with: "", options: .regularExpression)
        // Remover numeración de listas
        result = result.replacingOccurrences(of: #"(?m)^\s*\d+\.\s+"#, with: "", options: .regularExpression)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Persistencia
    
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
