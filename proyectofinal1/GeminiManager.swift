// GeminiManager.swift - Gestor con Chat Conversacional
import Foundation
import SwiftUI

@MainActor
class GeminiManager: ObservableObject {
    static let shared = GeminiManager()
    
    @Published var lastResponse = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var conversationHistory: [ChatMessage] = []
    
    private var apiKey = ""
    private var currentModel = "gemini-2.5-flash"
    
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
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        config.httpMaximumConnectionsPerHost = 5
        config.waitsForConnectivity = false
        return URLSession(configuration: config)
    }()
    
    private var responseCache: [String: CachedResponse] = [:]
    private struct CachedResponse {
        let text: String
        let timestamp: Date
        let ttl: TimeInterval = 300
        
        var isValid: Bool {
            Date().timeIntervalSince(timestamp) < ttl
        }
    }
    
    private let availableModels = [
        "gemini-2.5-flash",
        "gemini-2.5-flash-lite",
        "gemini-2.0-flash",
        "gemini-2.5-pro"
    ]
    
    private var baseURL: String {
        "https://generativelanguage.googleapis.com/v1beta/models/\(currentModel):generateContent"
    }
    
    // MARK: - Inicializador
    init() {
        self.apiKey = "AIzaSyBlaZqguMW6AJGZKJlVAMJAIMo3KpLTjQY"
        loadConversationHistory()
    }
    
    // MARK: - Configuración
    func configure(apiKey: String) {
        _ = configureAPIKey(apiKey)
    }
    
    func configureAPIKey(_ key: String) -> Bool {
        guard !key.isEmpty, key.starts(with: "AIza") else {
            errorMessage = "API Key inválida"
            return false
        }
        self.apiKey = key
        errorMessage = ""
        return true
    }
    
    func setModel(_ model: String) {
        guard availableModels.contains(model) else { return }
        currentModel = model
        print("🔄 Modelo cambiado a: \(model)")
    }
    
    // MARK: - Test de conexión
    func testConnection(completion: @escaping (Bool) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            let success = await self.testConnection()
            completion(success)
        }
    }
    
    func testConnection() async -> Bool {
        print("🔍 Iniciando test de conexión...")
        currentModel = "gemini-2.5-flash"
        errorMessage = ""
        lastResponse = ""
        
        print("Probando modelo: \(currentModel)")
        let success = await sendRequestOptimized(prompt: "Di solo: OK", maxTokens: 50, includeHistory: false)
        
        if success {
            print("✅ Modelo funcionando: \(currentModel)")
            return true
        } else {
            print("❌ Falló \(currentModel): \(errorMessage)")
            errorMessage = "No se pudo conectar con Gemini"
            return false
        }
    }
    
    // MARK: - Chat Conversacional Principal
    
    /// Enviar mensaje en modo chat (mantiene historial)
    func sendChatMessage(_ userMessage: String) async {
        // Agregar mensaje del usuario al historial
        let userMsg = ChatMessage(role: "user", text: userMessage)
        conversationHistory.append(userMsg)
        saveConversationHistory()
        
        // Enviar con historial completo
        let success = await sendRequestOptimized(
            prompt: userMessage,
            maxTokens: 800,
            includeHistory: true
        )
        
        if success && !lastResponse.isEmpty {
            // Agregar respuesta al historial
            let modelMsg = ChatMessage(role: "model", text: lastResponse)
            conversationHistory.append(modelMsg)
            saveConversationHistory()
        }
    }
    
    /// Limpiar historial del chat
    func clearConversation() {
        conversationHistory.removeAll()
        saveConversationHistory()
        print("🧹 Historial del chat limpiado")
    }
    
    // MARK: - Funciones Especializadas
    
    func getProductRecommendations(category: String, userPreferences: String) async {
        let prompt = """
        Dame 3 recomendaciones de \(category)\(userPreferences.isEmpty ? "" : " considerando: \(userPreferences)").
        Sé breve: nombre, precio aproximado y 1 razón clave para cada uno.
        """
        _ = await sendRequestOptimized(prompt: prompt, maxTokens: 600, includeHistory: false)
    }
    
    func generateFreeResponse(prompt: String) async {
        _ = await sendRequestOptimized(prompt: prompt, maxTokens: 800, includeHistory: false)
    }
    
    func getTechnicalSupport(question: String, productContext: String) async {
        let prompt = """
        \(productContext.isEmpty ? "" : "Sobre \(productContext): ")\(question)
        Dame una solución directa y práctica en 3-4 pasos.
        """
        _ = await sendRequestOptimized(prompt: prompt, maxTokens: 700, includeHistory: false)
    }
    
    // MARK: - Función Principal Optimizada
    private func sendRequestOptimized(prompt: String, maxTokens: Int = 800, includeHistory: Bool = false) async -> Bool {
        isLoading = true
        errorMessage = ""
        lastResponse = ""
        
        // Verificar caché solo si no incluye historial
        if !includeHistory {
            let cacheKey = "\(currentModel):\(prompt)"
            if let cached = responseCache[cacheKey], cached.isValid {
                print("💾 Usando respuesta en caché")
                lastResponse = cached.text
                isLoading = false
                return true
            }
        }
        
        guard !apiKey.isEmpty, apiKey.starts(with: "AIza") else {
            errorMessage = "API Key inválida"
            isLoading = false
            return false
        }
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            errorMessage = "URL inválida"
            isLoading = false
            return false
        }
        
        // ✅ Construir contenidos con historial si es necesario
        var contents: [[String: Any]] = []
        
        if includeHistory && !conversationHistory.isEmpty {
            // Incluir últimos 10 mensajes para contexto (5 intercambios)
            let recentHistory = conversationHistory.suffix(10)
            for msg in recentHistory {
                contents.append([
                    "role": msg.role,
                    "parts": [["text": msg.text]]
                ])
            }
        } else {
            // Solo el mensaje actual
            contents.append([
                "role": "user",
                "parts": [["text": prompt]]
            ])
        }
        
        // ✅ System instruction para respuestas naturales y breves
        let systemPrompt = """
        Eres un asistente amigable y experto en tecnología. Tus respuestas deben ser:
        - Breves y directas (máximo 3-4 párrafos cortos)
        - Conversacionales y naturales (como si hablaras con un amigo)
        - Sin copiar-pegar información
        - Con ejemplos concretos cuando sea útil
        - En español latino informal pero profesional
        
        IMPORTANTE: No uses listas largas ni texto formal. Escribe como si estuvieras chateando.
        """
        
        let requestBody: [String: Any] = [
            "contents": contents,
            "generationConfig": [
                "temperature": 0.9,  // ✅ Más creativo y natural
                "maxOutputTokens": maxTokens,
                "topP": 0.95,
                "topK": 40,
                "responseModalities": ["TEXT"]
            ],
            "safetySettings": [
                ["category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_ONLY_HIGH"]
            ],
            "systemInstruction": [
                "parts": [["text": systemPrompt]]
            ]
        ]
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 15
            
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            
            let startTime = CFAbsoluteTimeGetCurrent()
            print("📤 Enviando request a: \(currentModel)")
            
            let (data, response) = try await urlSession.data(for: request)
            
            let endTime = CFAbsoluteTimeGetCurrent()
            print("⏱️ Tiempo: \(String(format: "%.2f", endTime - startTime))s")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Respuesta inválida"
                isLoading = false
                return false
            }
            
            print("📊 Status: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorData["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    errorMessage = "API: \(message)"
                } else {
                    errorMessage = "HTTP \(httpResponse.statusCode)"
                }
                isLoading = false
                return false
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                errorMessage = "JSON inválido"
                isLoading = false
                return false
            }
            
            guard let candidates = jsonResponse["candidates"] as? [[String: Any]], !candidates.isEmpty else {
                errorMessage = "Sin respuesta del modelo"
                isLoading = false
                return false
            }
            
            let firstCandidate = candidates[0]
            
            guard let content = firstCandidate["content"] as? [String: Any] else {
                errorMessage = "Sin contenido en respuesta"
                isLoading = false
                return false
            }
            
            guard let parts = content["parts"] as? [[String: Any]], !parts.isEmpty else {
                if let finishReason = firstCandidate["finishReason"] as? String {
                    errorMessage = finishReason == "MAX_TOKENS" ? "Respuesta muy larga, intenta ser más específico" : "Sin respuesta (Razón: \(finishReason))"
                } else {
                    errorMessage = "Sin texto en respuesta"
                }
                isLoading = false
                return false
            }
            
            guard let text = parts[0]["text"] as? String, !text.isEmpty else {
                errorMessage = "Texto vacío"
                isLoading = false
                return false
            }
            
            lastResponse = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Guardar en caché solo si no es chat
            if !includeHistory {
                let cacheKey = "\(currentModel):\(prompt)"
                responseCache[cacheKey] = CachedResponse(text: lastResponse, timestamp: Date())
                cleanOldCache()
            }
            
            print("✅ Respuesta: \(lastResponse.count) chars")
            isLoading = false
            return true
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet: errorMessage = "Sin Internet"
            case .timedOut: errorMessage = "Timeout"
            case .cannotFindHost: errorMessage = "No se puede conectar"
            default: errorMessage = "Error de red"
            }
            print("❌ URLError: \(error)")
            
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            print("❌ Error: \(error)")
        }
        
        isLoading = false
        return false
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
    
    // MARK: - Utilidades
    private func cleanOldCache() {
        let validCache = responseCache.filter { $0.value.isValid }
        if validCache.count < responseCache.count {
            responseCache = validCache
            print("🧹 Caché limpiado (\(responseCache.count) entradas)")
        }
    }
    
    func clearCache() {
        responseCache.removeAll()
        print("🧹 Caché vaciado completamente")
    }
}

// MARK: - Debug
extension GeminiManager {
    func printDebugInfo() {
        print("""
        
        ═══════════════════════════════════
        🔍 GEMINI DEBUG
        ═══════════════════════════════════
        Modelo: \(currentModel)
        API Key: \(apiKey.isEmpty ? "❌ NO" : "✅ SÍ")
        URL: \(baseURL)
        Error: \(errorMessage.isEmpty ? "Ninguno" : errorMessage)
        Respuesta: \(lastResponse.isEmpty ? "Vacía" : "\(lastResponse.count) chars")
        Historial: \(conversationHistory.count) mensajes
        Caché: \(responseCache.count) entradas
        ═══════════════════════════════════
        
        """)
    }
}
