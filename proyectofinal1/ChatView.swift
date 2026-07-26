// ChatView.swift - Vista de Chat estilo WhatsApp
import SwiftUI

struct ChatView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var geminiManager: GeminiManager
    @State private var messageText = ""
    @State private var showClearAlert = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            // Fondo estilo WhatsApp
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            if geminiManager.conversationHistory.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(geminiManager.conversationHistory) { message in
                                    MessageBubbleWhatsApp(message: message)
                                        .id(message.id)
                                }
                            }
                            
                            // Loading indicator
                            if geminiManager.isLoading {
                                LoadingBubbleWhatsApp()
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .padding(.bottom, 80)
                    }
                    .onChange(of: geminiManager.conversationHistory.count) {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: geminiManager.isLoading) {
                        scrollToBottom(proxy: proxy)
                    }
                }
                
                // Input area (fixed at bottom)
                VStack(spacing: 0) {
                    // Error message
                    if !geminiManager.errorMessage.isEmpty {
                        ErrorBannerCompact(message: geminiManager.errorMessage)
                    }
                    
                    inputView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(localizationManager.translate("chat.title"))
                        .font(.system(size: fontSize + 2, weight: .semibold))
                    if geminiManager.isLoading {
                        Text(localizationManager.translate("chat.typing"))
                            .font(.system(size: fontSize - 4, weight: .regular))
                            .foregroundColor(.green)
                    } else {
                        Text(localizationManager.translate("chat.online"))
                            .font(.system(size: fontSize - 4, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: { showClearAlert = true }) {
                        Label(localizationManager.translate("chat.clearChat"), systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert(localizationManager.translate("chat.clearChat"), isPresented: $showClearAlert) {
            Button(localizationManager.translate("cancel"), role: .cancel) {}
            Button(localizationManager.translate("delete"), role: .destructive) {
                geminiManager.clearConversation()
            }
        } message: {
            Text(localizationManager.translate("chat.clearConfirm"))
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                Text(localizationManager.translate("chat.emptyTitle"))
                    .font(.system(size: fontSize + 2, weight: .bold))
                
                Text(localizationManager.translate("chat.emptySubtitle"))
                    .font(.system(size: fontSize, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Suggestions
            VStack(spacing: 12) {
                SuggestionBubble(
                    icon: "hand.wave.fill",
                    text: localizationManager.translate("chat.suggestion1"),
                    action: sendSuggestion,
                    fontSize: fontSize
                )
                
                SuggestionBubble(
                    icon: "iphone",
                    text: localizationManager.translate("chat.suggestion2"),
                    action: sendSuggestion,
                    fontSize: fontSize
                )
                
                SuggestionBubble(
                    icon: "wrench.and.screwdriver",
                    text: localizationManager.translate("chat.suggestion3"),
                    action: sendSuggestion,
                    fontSize: fontSize
                )
                
                SuggestionBubble(
                    icon: "sparkles",
                    text: localizationManager.translate("chat.suggestion4"),
                    action: sendSuggestion,
                    fontSize: fontSize
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    // MARK: - Input View
    private var inputView: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // Text field
            HStack {
                TextField(localizationManager.translate("chat.messagePlaceholder"), text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: fontSize, weight: .regular))
                    .lineLimit(1...6)
                    .focused($isInputFocused)
                    .disabled(geminiManager.isLoading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            
            // Send button
            Button(action: sendMessage) {
                ZStack {
                    Circle()
                        .fill(canSend ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helpers
    private var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !geminiManager.isLoading
    }
    
    private func sendMessage() {
        guard canSend else { return }
        
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        messageText = ""
        
        // Agregar mensaje del usuario al historial
        let userMsg = GeminiManager.ChatMessage(role: "user", text: message)
        geminiManager.conversationHistory.append(userMsg)
        
        Task {
            // Usar sendChatMessage para mantener contexto completo
            await geminiManager.sendChatMessage(message)
        }
    }
    
    private func sendSuggestion(text: String) {
        messageText = text
        sendMessage()
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let lastMessage = geminiManager.conversationHistory.last {
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
}

// MARK: - Loading Bubble WhatsApp Style
struct LoadingBubbleWhatsApp: View {
    @State private var animateOpacity = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            HStack(spacing: 6) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 8, height: 8)
                        .opacity(animateOpacity ? 0.3 : 1)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(i) * 0.2),
                            value: animateOpacity
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray5))
            .cornerRadius(18)
            
            Spacer(minLength: 60)
        }
        .onAppear { animateOpacity = true }
    }
}

// MARK: - Suggestion Bubble
struct SuggestionBubble: View {
    let icon: String
    let text: String
    let action: (String) -> Void
    let fontSize: Double
    
    var body: some View {
        Button(action: { action(text) }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 32)
                
                Text(text)
                    .font(.system(size: fontSize, weight: .regular))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.blue.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Error Banner Compact
struct ErrorBannerCompact: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .font(.caption)
                .foregroundColor(.red)
            
            Text(message)
                .font(.system(size: fontSize - 4, weight: .regular))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ChatView()
            .environmentObject(GeminiManager.shared)
    }
}
