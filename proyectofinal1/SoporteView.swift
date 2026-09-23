import SwiftUI

// MARK: - Modelo de Mensaje
struct SupportBotMessage: Identifiable, Codable {
    let id: UUID
    let role: String
    let text: String
    
    init(role: String, text: String) {
        self.id = UUID()
        self.role = role
        self.text = text
    }
}

// MARK: - Banner de Errores
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
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var cartManager: CartManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @ObservedObject private var store = ProductStore.shared
    let message: SupportBotMessage

    private var isUser: Bool { message.role == "user" }

    private var mentionedProducts: [Product] {
        guard !isUser else { return [] }
        return store.products
            .filter { message.text.localizedCaseInsensitiveContains($0.name) }
            .sorted { $0.name.count > $1.name.count }
            .prefix(3)
            .map { $0 }
    }

    var body: some View {
        HStack(alignment: .bottom) {
            if isUser { Spacer(minLength: 24) }

            VStack(alignment: .leading, spacing: 6) {
                Text(message.text)
                    .font(.system(size: fontSize - 2, weight: .regular))
                    .foregroundColor(isUser ? .white : (themeManager.isDarkMode ? .white : .primary))

                if !mentionedProducts.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(mentionedProducts) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                                    .environmentObject(themeManager)
                                    .environmentObject(localizationManager)
                                    .environmentObject(cartManager)
                            } label: {
                                Label("Ver y comprar \(product.name)", systemImage: "bag.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.top, 4)
                }
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
    @EnvironmentObject var cartManager: CartManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @StateObject private var gemini = GeminiManager.shared
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var speechSynthesizer = SpeechSynthesizer()
    @State private var messageText = ""
    @State private var showClearAlert = false
    @State private var isVoiceMode = false
    @State private var liveReply = ""
    @FocusState private var isInputFocused: Bool
    @State private var supportHistory: [SupportBotMessage] = []
    
    private var isLoading: Bool { gemini.isLoading }
    
    // El bloque de contacto/horario solo se muestra antes de iniciar la conversación
    private var showHeader: Bool { supportHistory.isEmpty }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
                })
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Barra superior (SIEMPRE visible: título, estado, WhatsApp, menú de vaciar chat)
                    topBar
                        .padding(.top, geo.safeAreaInsets.top)
                    
                    // MARK: - Bloque de contacto/horario (desaparece al iniciar el chat)
                    if showHeader {
                        contactInfoSection
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
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
                                
                                if isLoading && liveReply.isEmpty {
                                    LoadingBubble()
                                        .environmentObject(themeManager)
                                }
                                
                                if !liveReply.isEmpty {
                                    MessageBubble(message: SupportBotMessage(role: "model", text: liveReply))
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
                        .onChange(of: liveReply) {
                            scrollToBottom(proxy: proxy)
                        }
                    }
                    
                    // Área de entrada (texto o voz)
                    VStack(spacing: 0) {
                        if !gemini.errorMessage.isEmpty {
                            ErrorBanner(message: gemini.errorMessage)
                                .environmentObject(themeManager)
                        }
                        if isVoiceMode {
                            voiceInputView
                        } else {
                            supportInputView
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: showHeader)
            }
            .ignoresSafeArea(.container, edges: .top)
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
        .onDisappear {
            speechRecognizer.stop()
            speechSynthesizer.stop()
        }
    }
    
    // MARK: - Barra superior propia
    private var topBar: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 38, height: 38)
                
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(localizationManager.translate("support.title"))
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                
                Text(isLoading
                     ? localizationManager.translate("support.typing")
                     : localizationManager.translate("support.available"))
                    .font(.system(size: fontSize - 5, weight: .regular))
                    .foregroundColor(isLoading ? .green : .secondary)
            }
            
            Spacer()
            
            // Alterna entre modo voz y modo texto (misma conversación)
            Button(action: toggleVoiceMode) {
                Image(systemName: isVoiceMode ? "keyboard.fill" : "mic.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isVoiceMode ? .white : (themeManager.isDarkMode ? .orange : .primary))
                    .frame(width: 34, height: 34)
                    .background(
                        Circle().fill(isVoiceMode ? Color.orange : Color.orange.opacity(0.15))
                    )
            }
            
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
                    .font(.system(size: 20))
                    .foregroundColor(themeManager.isDarkMode ? .orange : .primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
        }))
    }
    
    // MARK: - Bloque de contacto/horario
    @ViewBuilder
    private var contactInfoSection: some View {
        VStack(spacing: 12) {
            // Información de contacto
            HStack(spacing: 12) {
                Button(action: callSupport) {
                    HStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("+51 951012633")
                            .font(.system(size: fontSize - 3, weight: .regular))
                            .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Button(action: emailSupport) {
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.purple)
                        Text("soporte@tech.com")
                            .font(.system(size: fontSize - 3, weight: .regular))
                            .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                }
                
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
                        Text(localizationManager.translate("support.available"))
                            .font(.system(size: fontSize - 3, weight: .semibold))
                            .foregroundColor(.green)
                    }
                    
                    Text(localizationManager.translate("support.hours"))
                        .font(.system(size: fontSize - 4, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(localizationManager.translate("support.avgResponseTime"))
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
    
    // MARK: - Entrada de voz
    private var voiceInputView: some View {
        VStack(spacing: 14) {
            Group {
                if speechRecognizer.authorizationDenied {
                    Text(localizationManager.translate("support.voicePermissionDenied"))
                } else if speechRecognizer.isListening {
                    Text(speechRecognizer.transcript.isEmpty
                         ? localizationManager.translate("support.voiceListening")
                         : speechRecognizer.transcript)
                } else if speechSynthesizer.isSpeaking {
                    Text(localizationManager.translate("support.voiceResponding"))
                } else {
                    Text(localizationManager.translate("support.voiceIdle"))
                }
            }
            .font(.system(size: fontSize - 2, weight: .medium))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(minHeight: 40)

            HStack(spacing: 20) {
                Button(action: toggleListening) {
                    ZStack {
                        Circle()
                            .fill(speechRecognizer.isListening ? Color.red : Color.orange)
                            .frame(width: 64, height: 64)
                            .shadow(color: (speechRecognizer.isListening ? Color.red : Color.orange).opacity(0.4), radius: 12, x: 0, y: 4)
                        Image(systemName: speechRecognizer.isListening ? "stop.fill" : "mic.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(isLoading || speechSynthesizer.isSpeaking)

                if speechSynthesizer.isSpeaking {
                    Button {
                        if speechSynthesizer.isPaused { speechSynthesizer.resume() } else { speechSynthesizer.pause() }
                    } label: {
                        Image(systemName: speechSynthesizer.isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.orange.opacity(0.15)))
                    }

                    Button {
                        speechSynthesizer.stop()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.secondary.opacity(0.12)))
                    }
                }
            }
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
        }))
    }

    // MARK: - Funciones de ayuda
    private var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    private let allowedKeywords: [String] = [
        "iphone", "ipad", "mac", "macbook", "airpods", "apple watch", "watch", "apple",
        "repuesto", "repuestos", "pieza", "piezas", "pantalla", "pantallas", "bateria", "batería",
        "camara", "cámara", "puerto de carga", "conector", "altavoz", "altavoces", "parlante",
        "microfono", "micrófono", "boton", "botón", "tapa", "carcasa", "flex", "placa", "modem",
        "antena", "vidrio", "tactil", "táctil", "cristal",
        "reparacion", "reparación", "reparar", "garantia", "garantía", "instalacion", "instalación",
        "diagnostico", "diagnóstico", "servicio tecnico", "servicio técnico", "precio", "precios",
        "costo", "cotizacion", "cotización", "tiempo de entrega", "carrito", "comprar", "cuanto cuesta",
        "cuánto cuesta",
        "recomien", "recomendaci", "conviene", "elegir", "mejor opcion", "mejor opción",
        "cual me", "cuál me", "que me", "qué me", "estudiante", "profesor", "universidad",
        "colegio", "trabajo", "oficina", "diseño", "diseñador", "editar video", "edicion",
        "edición", "gamer", "juegos", "videojuegos", "fotografia", "fotografía",
        "presupuesto", "modelo", "diferencia", "comparar", "producto", "productos",
        "catalogo", "catálogo", "quiero comprar", "nuevo", "nueva",
        "telefono", "teléfono", "numero", "número", "llamar", "llamada", "contacto",
        "contactar", "correo", "email", "whatsapp", "hablar con alguien", "asesor",
        "horario", "atencion", "atención",
        "color", "colores", "ficha", "tecnica", "técnica", "procesador", "chip",
        "air", "duo", "pro max", "plegable", "almacenamiento", "gb",
        "apple intelligence", "siri", "usb-c", "wifi", "bluetooth",
        "stock", "disponible", "disponibles", "tienen", "tienes", "hay", "tienda", "inventario",
        "cuales", "cuáles", "modelos", "opciones", "lista", "decir", "me puedes",
        "accesorios", "tv", "casa", "watch",
        "hola", "buenas", "buenos dias", "buenos días", "buenas tardes", "buenas noches",
        "gracias", "ayuda", "necesito ayuda",
        // English keywords
        "price", "prices", "cost", "how much", "buy", "purchase", "order", "cart", "checkout",
        "stock", "available", "availability", "have", "do you have", "repair", "repairs",
        "part", "parts", "spare", "screen", "battery", "charging", "charger", "color", "colors",
        "spec", "specs", "specification", "specifications", "chip", "processor", "storage",
        "recommend", "recommendation", "recommendations", "which", "what", "best", "compare",
        "comparison", "difference", "catalog", "catalogue", "list", "all", "everything",
        "accessory", "accessories", "warranty", "service", "technician", "technical", "support",
        "model", "models", "iphone", "ipad", "mac", "macbook", "airpods", "watch", "apple",
        "student", "work", "office", "gamer", "games", "gaming", "photo", "photography", "video",
        "budget", "message", "call", "contact", "email", "whatsapp", "hours", "help",
        "hello", "hi", "hey", "good morning", "good afternoon", "good evening", "thanks", "thank you",
        "please", "want", "need", "looking for", "foldable", "pro max", "air", "duo"
    ]

    private func isOnTopic(_ text: String) -> Bool {
        let lower = text.lowercased()
        return allowedKeywords.contains { lower.contains($0) }
    }

    private func sendMessage() {
        guard canSend else { return }
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        messageText = ""
        isInputFocused = false
        Task { _ = await deliver(text, speak: false) }
    }

    /// Envía un mensaje al asistente y guarda la respuesta en el historial compartido.
    /// Lo usan tanto el modo texto como el modo voz para mantener una sola conversación.
    private func deliver(_ text: String, speak: Bool) async -> String {
        supportHistory.append(SupportBotMessage(role: "user", text: text))
        saveSupportHistory()

        guard isOnTopic(text) else {
            let offTopicReply = localizationManager.translate("support.offTopic")
            supportHistory.append(SupportBotMessage(role: "model", text: offTopicReply))
            saveSupportHistory()
            if speak { speechSynthesizer.speak(offTopicReply) }
            return offTopicReply
        }

        var spokenChars = 0
        var spokeFirst = false

        await gemini.sendChatMessageStreaming(text) { partial in
            liveReply = partial
            if speak, !spokeFirst, let end = Self.firstSentenceEnd(partial), end >= 12 {
                spokeFirst = true
                spokenChars = end
                speechSynthesizer.speak(String(partial.prefix(end)))
            }
        }

        liveReply = ""
        let replyText = gemini.errorMessage.isEmpty
            ? gemini.lastResponse
            : gemini.errorMessage

        if !replyText.isEmpty {
            supportHistory.append(SupportBotMessage(role: "model", text: replyText))
            saveSupportHistory()
        }

        if speak, !replyText.isEmpty {
            if spokeFirst {
                let remainder = String(replyText.dropFirst(spokenChars))
                if !remainder.isEmpty { speechSynthesizer.enqueue(remainder) }
            } else {
                speechSynthesizer.speak(replyText)
            }
        }
        return replyText
    }

    /// Índice justo después del primer punto/interrogación/exclamación (fin de la 1ª oración).
    private static func firstSentenceEnd(_ s: String) -> Int? {
        let chars = Array(s)
        for i in 0..<chars.count where chars[i] == "." || chars[i] == "?" || chars[i] == "!" {
            return i + 1
        }
        return nil
    }

    // MARK: - Modo voz
    private func toggleVoiceMode() {
        isVoiceMode.toggle()
        isInputFocused = false
        if isVoiceMode {
            speechSynthesizer.stop()
        } else {
            speechRecognizer.stop()
        }
    }

    private func toggleListening() {
        if speechRecognizer.isListening {
            speechRecognizer.stop()
            let text = speechRecognizer.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            speechRecognizer.transcript = ""
            guard !text.isEmpty else { return }
            Task {
                _ = await deliver(text, speak: true)
            }
        } else {
            speechSynthesizer.stop()
            speechRecognizer.start()
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
           let decoded = try? JSONDecoder().decode([SupportBotMessage].self, from: data) {
            supportHistory = decoded
        }
    }
    
    private func callSupport() {
        guard let url = URL(string: "tel://51951012633") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func emailSupport() {
        guard let url = URL(string: "mailto:soporte@tech.com") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openWhatsApp() {
        let phoneNumber = "51951012633"
        let message = localizationManager.translate("support.whatsappMessage")
        
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

#Preview {
    NavigationView {
        SoporteView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
