// APIKeySetupView.swift
import SwiftUI

struct APIKeySetupView: View {
    @StateObject private var gemini = GeminiManager()
    @State private var apiKeyInput = ""
    @State private var isConfigured = false
    @State private var showError = false
    
    var body: some View {
        Group {
            if isConfigured {
                // Tu app principal
                MainAppView(gemini: gemini)
            } else {
                // Vista de configuración
                configurationView
            }
        }
    }
    
    var configurationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "key.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Configura tu API Key")
                .font(.title)
                .bold()
            
            Text("Necesitas una API Key de Google AI Studio")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            SecureField("Pega tu API Key aquí", text: $apiKeyInput)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button(action: configureKey) {
                Text("Conectar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(apiKeyInput.isEmpty)
            
            Link("¿Cómo obtener una API Key?",
                 destination: URL(string: "https://makersuite.google.com/app/apikey")!)
                .font(.footnote)
            
            if showError {
                Text("❌ API Key inválida")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
    
    func configureKey() {
        if gemini.configureAPIKey(apiKeyInput) {
            // Guarda en UserDefaults para no pedir cada vez
            UserDefaults.standard.set(apiKeyInput, forKey: "gemini_api_key")
            
            Task {
                let success = await gemini.testConnection()
                if success {
                    isConfigured = true
                    showError = false
                } else {
                    showError = true
                }
            }
        } else {
            showError = true
        }
    }
}

// Vista principal de tu app
struct MainAppView: View {
    @ObservedObject var gemini: GeminiManager
    
    var body: some View {
        VStack {
            Text("¡App funcionando!")
            Text("Última respuesta:")
            Text(gemini.lastResponse)
                .padding()
        }
    }
}

#Preview {
    APIKeySetupView()
}
