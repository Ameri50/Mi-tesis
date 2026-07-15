import SwiftUI

// MARK: - Modelo de Mensaje
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let role: String
    let text: String
    
    init(role: String, text: String) {
        self.id = UUID()
        self.role = role
        self.text = text
    }
}

// MARK: - Banner de Errors
struct ErrorBanner: View {
    @EnvironmentObject var themeManager: ThemeManager
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(message)
                .font(.system(size: 12, weight: .regular))
                .lineLimit(2)
            Spacer()
        }
        .padding(8)
        .background(Color.red.opacity(0.1))
        .foregroundColor(.red)
    }
}

// MARK: - Burbuja de Mensaje
struct MessageBubble: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    let message: ChatMessage
    
    private var isUser: Bool { message.role == "user" }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if isUser { Spacer(minLength: 24) }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(message.text)
                    .font(.system(size: fontSize - 2, weight: .regular))
                    .foregroundColor(isUser ? .white : (themeManager.isDarkMode ? .white : .primary))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(isUser ? Color.orange : Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray5
            }))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            if !isUser { Spacer(minLength: 24) }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Burbuja de Carga
struct LoadingBubble: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray5
            }))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            Spacer(minLength: 24)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Tarjeta de Categoría de Soporte
struct SupportCategoryCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: (String) -> Void
    
    var body: some View {
        Button(action: {
            action(title)
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: fontSize - 2, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    
                    Text(subtitle)
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
            }))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.2 : 0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Vista Principal de Soporte
struct SoporteView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @StateObject private var gemini = GeminiManager.shared
    @State private var messageText = ""
    @State private var showClearAlert = false
    @FocusState private var isInputFocused: Bool
    @State private var supportHistory: [ChatMessage] = []
    @FocusState private var isLoadingUnused: Bool // no-op, mantenido por compatibilidad de layout
    
    private var isLoading: Bool { gemini.isLoading }
    
    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
            })
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header Superior
                headerSection
                
                // Chat principal
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            if supportHistory.isEmpty {
                                emptySupportStateView
                            } else {
                                ForEach(supportHistory) { message in
                                    MessageBubble(message: message)
                                        .environmentObject(themeManager)
                                }
                            }
                            
                            if isLoading {
                                LoadingBubble()
                                    .environmentObject(themeManager)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .padding(.bottom, 80)
                    }
                    .onChange(of: supportHistory.count) {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: isLoading) {
                        scrollToBottom(proxy: proxy)
                    }
                }
                
                // Área de entrada de texto
                VStack(spacing: 0) {
                    if !gemini.errorMessage.isEmpty {
                        ErrorBanner(message: gemini.errorMessage)
                            .environmentObject(themeManager)
                    }
                    supportInputView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    HStack(spacing: 6) {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.caption)
                        Text(localizationManager.translate("support.title"))
                            .font(.system(size: fontSize, weight: .semibold))
                    }
                    .foregroundColor(themeManager.isDarkMode ? .orange : .primary)
                    
                    Text(isLoading
                         ? localizationManager.translate("support.typing")
                         : localizationManager.translate("support.available"))
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundColor(isLoading ? .green : .secondary)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: openWhatsApp) {
                        Image(systemName: "bubble.right.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.green)
                    }
                    
                    Menu {
                        Button(role: .destructive, action: { showClearAlert = true }) {
                            Label(localizationManager.translate("support.clearChat"), systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(themeManager.isDarkMode ? .orange : .primary)
                    }
                }
            }
        }
        .alert(localizationManager.translate("support.clearChat"), isPresented: $showClearAlert) {
            Button(localizationManager.translate("support.cancel"), role: .cancel) {}
            Button(localizationManager.translate("support.clear"), role: .destructive) {
                supportHistory.removeAll()
                gemini.clearConversation()
                saveSupportHistory()
            }
        } message: {
            Text(localizationManager.translate("support.clearMessage"))
        }
        .onAppear {
            loadSupportHistory()
        }
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Logo y nombre de empresa
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "headphones.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tech Support")
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    
                    Text("Centro de Asistencia")
                        .font(.system(size: fontSize - 3, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Información de contacto
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    Text("+51 951012633")
                        .font(.system(size: fontSize - 3, weight: .regular))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                HStack(spacing: 8) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.purple)
                    Text("soporte@tech.com")
                        .font(.system(size: fontSize - 3, weight: .regular))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // Hora de atención y estado
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Disponible")
                            .font(.system(size: fontSize - 3, weight: .semibold))
                            .foregroundColor(.green)
                    }
                    
                    Text("Lun - Vie: 9:00 - 18:00")
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Tiempo promedio")
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text("~5 min")
                            .font(.system(size: fontSize - 3, weight: .semibold))
                    }
                    .foregroundColor(themeManager.isDarkMode ? .orange : .primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray6
            }))
            .cornerRadius(12)
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }
    
    // MARK: - Vista vacía (inicio)
    private var emptySupportStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 100, height: 100)
                Image(systemName: "lifepreserver.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 8) {
                Text(localizationManager.translate("support.heading"))
                    .font(.system(size: fontSize + 2, weight: .bold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                Text(localizationManager.translate("support.subheading"))
                    .font(.system(size: fontSize - 2))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                SupportCategoryCard(
                    icon: "iphone.gen3",
                    title: localizationManager.translate("support.category1.title"),
                    subtitle: localizationManager.translate("support.category1.subtitle"),
                    color: .blue,
                    action: sendSuggestion
                )
                SupportCategoryCard(
                    icon: "wifi.router",
                    title: localizationManager.translate("support.category2.title"),
                    subtitle: localizationManager.translate("support.category2.subtitle"),
                    color: .green,
                    action: sendSuggestion
                )
                SupportCategoryCard(
                    icon: "bolt.fill",
                    title: localizationManager.translate("support.category3.title"),
                    subtitle: localizationManager.translate("support.category3.subtitle"),
                    color: .orange,
                    action: sendSuggestion
                )
                SupportCategoryCard(
                    icon: "externaldrive",
                    title: localizationManager.translate("support.category4.title"),
                    subtitle: localizationManager.translate("support.category4.subtitle"),
                    color: .purple,
                    action: sendSuggestion
                )
            }
            .environmentObject(themeManager)
            .environmentObject(localizationManager)
            .padding(.horizontal)
            Spacer()
        }
    }
    
    // MARK: - Entrada de texto
    private var supportInputView: some View {
        VStack(spacing: 0) {
            if isInputFocused {
                HStack {
                    Spacer()
                    Button {
                        isInputFocused = false
                    } label: {
                        Label(localizationManager.translate("support.hideKeyboard"), systemImage: "keyboard.chevron.compact.down")
                            .font(.system(size: fontSize - 3, weight: .medium))
                            .foregroundColor(themeManager.isDarkMode ? .orange : .blue)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
                .padding(.horizontal, 8)
                .background(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray6
                }))
            }
            
            HStack(alignment: .bottom, spacing: 8) {
                TextField(localizationManager.translate("support.placeholder"), text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: fontSize - 2))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    .lineLimit(1...6)
                    .focused($isInputFocused)
                    .disabled(isLoading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(UIColor { _ in
                        themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemGray6
                    }))
                    .cornerRadius(20)
                
                Button(action: sendMessage) {
                    Circle()
                        .fill(canSend ? .orange : .gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .overlay(Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white))
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            }))
        }
    }
    
    // MARK: - Funciones de ayuda
    private var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    private func sendMessage() {
        guard canSend else { return }
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        messageText = ""
        isInputFocused = false
        
        supportHistory.append(ChatMessage(role: "user", text: text))
        saveSupportHistory()
        
        Task {
            await gemini.sendChatMessage(text)
            
            let replyText = gemini.errorMessage.isEmpty
                ? gemini.lastResponse
                : gemini.errorMessage
            
            if !replyText.isEmpty {
                supportHistory.append(ChatMessage(role: "model", text: replyText))
                saveSupportHistory()
            }
        }
    }
    
    private func sendSuggestion(_ text: String) {
        messageText = "\(localizationManager.translate("support.issuePrefix")) \(text.lowercased())"
        sendMessage()
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let last = supportHistory.last {
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }
    
    private func saveSupportHistory() {
        if let data = try? JSONEncoder().encode(supportHistory) {
            UserDefaults.standard.set(data, forKey: "support_history")
        }
    }
    
    private func loadSupportHistory() {
        if let data = UserDefaults.standard.data(forKey: "support_history"),
           let decoded = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            supportHistory = decoded
        }
    }
    
    // MARK: - WhatsApp Method
    private func openWhatsApp() {
        let phoneNumber = "51951012633"
        let message = "¡Hola! 👋 Me gustaría obtener más información sobre sus productos."
        
        guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        let whatsappURL = "https://wa.me/\(phoneNumber)?text=\(encodedMessage)"
        
        guard let url = URL(string: whatsappURL) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        SoporteView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
