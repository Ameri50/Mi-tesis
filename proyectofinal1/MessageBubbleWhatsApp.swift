// MessageBubbleWhatsApp.swift
import SwiftUI

struct MessageBubbleWhatsApp: View {
    let message: GeminiManager.ChatMessage
    
    // MARK: - Computed Properties
    private var isUser: Bool { message.role == "user" }
    
    private var bubbleColor: Color {
        isUser ? .blue : Color(.systemGray5)
    }
    
    private var textColor: Color {
        isUser ? .white : .primary
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: isUser ? .trailing : .leading, spacing: 2) {
                // Message content
                messageBubble
                
                // Timestamp and status
                timestampView
            }
            
            if !isUser {
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Subviews
    private var messageBubble: some View {
        Text(message.text)
            .font(.body)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(bubbleColor)
            .foregroundColor(textColor)
            .cornerRadius(18)
            .textSelection(.enabled)
    }
    
    private var timestampView: some View {
        HStack(spacing: 4) {
            Text(formattedTime)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            if isUser {
                Image(systemName: "checkmark")
                    .font(.system(size: 10))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Helpers
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }
}

// MARK: - Configuration
extension MessageBubbleWhatsApp {
    /// Personalizar colores del bubble
    func bubbleStyle(userColor: Color, modelColor: Color) -> some View {
        let view = self
        // Aquí podrías agregar @State para colores personalizables
        return view
    }
}

// MARK: - Preview
#Preview("Usuario") {
    VStack(spacing: 8) {
        MessageBubbleWhatsApp(
            message: GeminiManager.ChatMessage(
                role: "user",
                text: "Hola, ¿cómo estás?"
            )
        )
        
        MessageBubbleWhatsApp(
            message: GeminiManager.ChatMessage(
                role: "user",
                text: "Este es un mensaje más largo para ver cómo se comporta el diseño con múltiples líneas de texto."
            )
        )
    }
    .padding()
}

#Preview("Modelo") {
    VStack(spacing: 8) {
        MessageBubbleWhatsApp(
            message: GeminiManager.ChatMessage(
                role: "model",
                text: "¡Hola! Estoy muy bien, gracias por preguntar. ¿En qué puedo ayudarte hoy?"
            )
        )
        
        MessageBubbleWhatsApp(
            message: GeminiManager.ChatMessage(
                role: "model",
                text: "Puedo ayudarte con código, explicaciones técnicas, y mucho más."
            )
        )
    }
    .padding()
}

