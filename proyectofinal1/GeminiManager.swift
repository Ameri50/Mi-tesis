// GeminiManager.swift - Gestor con Chat Conversacional (vía Cloud Function segura)
import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth

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

    // ⚠️ Ya NO hay API key aquí. La key vive únicamente en el servidor
    // (Firebase Cloud Function "geminiChat"), nunca en el cliente.
    private lazy var functions = Functions.functions(region: "us-central1")

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

        // Aseguramos que haya un usuario autenticado (la función lo exige).
        if Auth.auth().currentUser == nil {
            do {
                _ = try await Auth.auth().signInAnonymously()
            } catch {
                errorMessage = "No se pudo iniciar sesión para usar el chat."
                isLoading = false
                return
            }
        }

        // Historial reciente en el formato que espera la Cloud Function.
        let recentHistory = conversationHistory
            .dropLast() // el mensaje del usuario ya va aparte en "message"
            .suffix(10)
            .map { ["role": $0.role, "text": $0.text] }

        do {
            let result = try await functions.httpsCallable("geminiChat").call([
                "message": userMessage,
                "history": recentHistory
            ])

            if let data = result.data as? [String: Any],
               let text = data["text"] as? String, !text.isEmpty {
                lastResponse = text
                let modelMsg = ChatMessage(role: "model", text: text)
                conversationHistory.append(modelMsg)
                saveConversationHistory()
            } else {
                errorMessage = "Respuesta vacía del servidor"
            }
        } catch let error as NSError {
            errorMessage = friendlyMessage(for: error)
            print("❌ Error geminiChat: \(error)")
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
    private func friendlyMessage(for error: NSError) -> String {
        if error.domain == FunctionsErrorDomain,
           let code = FunctionsErrorCode(rawValue: error.code) {
            switch code {
            case .unauthenticated: return "Debes iniciar sesión para usar el chat"
            case .invalidArgument: return "Mensaje inválido"
            case .unavailable: return "Sin conexión con el servidor"
            case .resourceExhausted: return "Demasiadas solicitudes, espera un momento"
            default: return "No se pudo obtener respuesta"
            }
        }
        return "Error de red"
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
