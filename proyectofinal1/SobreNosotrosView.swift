import SwiftUI

struct SobreNosotrosView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @State private var selectedValor: String? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    themeManager.isDarkMode ? Color(UIColor(white: 0.08, alpha: 1)) : Color(UIColor(white: 0.98, alpha: 1)),
                    themeManager.isDarkMode ? Color(UIColor(white: 0.12, alpha: 1)) : Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sobre Nosotros")
                            .font(.system(size: fontSize + 2, weight: .bold))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        
                        Text("Nuestra historia & valores")
                            .font(.system(size: fontSize - 2, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: openWhatsApp) {
                        Image(systemName: "bubble.right.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.green))
                    }
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(themeManager.isDarkMode ? Color(UIColor(white: 0.13, alpha: 1)) : Color.white)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        heroSection
                        historiaSection
                        statsSection
                        misionVisionSection
                        valoresModernoSection
                        timelineSection
                        ctaSection
                    }
                    .padding(.vertical, 24)
                }
            }
            
            if let valor = selectedValor {
                DetalleValorView(valor: valor, isDarkMode: themeManager.isDarkMode, fontSize: fontSize, onDismiss: { selectedValor = nil })
            }
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.2), Color.orange.opacity(0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "building.2.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 8) {
                Text("Innovación & Excelencia")
                    .font(.system(size: fontSize + 4, weight: .bold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                
                Text("Transformando el futuro con tecnología de punta")
                    .font(.system(size: fontSize - 1, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
    }
    
    private var historiaSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 12, height: 12)
                    
                    Rectangle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
                
                Text("Nuestro Comienzo")
                    .font(.system(size: fontSize + 2, weight: .bold))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Hace más de 5 años, nuestro equipo decidió crear una solución innovadora para transformar la forma en que los clientes interactúan con las marcas.")
                    .font(.system(size: fontSize - 0.5, weight: .regular))
                    .foregroundColor(.gray)
                    .lineSpacing(1.6)
                
                Text("Lo que comenzó como una pequeña idea, se ha convertido en una plataforma confiable que sirve a miles de usuarios.")
                    .font(.system(size: fontSize - 0.5, weight: .regular))
                    .foregroundColor(.gray)
                    .lineSpacing(1.6)
            }
            .padding(16)
            .background(themeManager.isDarkMode ? Color(UIColor(white: 0.15, alpha: 1)) : Color.white)
            .cornerRadius(14)
        }
        .padding(.horizontal, 16)
    }
    
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(numero: "5+", titulo: "Años", color: .orange, isDarkMode: themeManager.isDarkMode)
            StatCard(numero: "10K+", titulo: "Usuarios", color: .blue, isDarkMode: themeManager.isDarkMode)
            StatCard(numero: "99%", titulo: "Satisfacción", color: .green, isDarkMode: themeManager.isDarkMode)
        }
        .padding(.horizontal, 16)
    }
    
    private var misionVisionSection: some View {
        VStack(spacing: 12) {
            MisionVisionCard(icon: "target", titulo: "Misión", descripcion: "Proporcionar herramientas innovadoras que permitan a nuestros clientes alcanzar sus objetivos", color: .blue, isDarkMode: themeManager.isDarkMode, fontSize: fontSize)
            
            MisionVisionCard(icon: "eye.fill", titulo: "Visión", descripcion: "Ser líderes reconocidos por excelencia, innovación y dedicación en la industria", color: .purple, isDarkMode: themeManager.isDarkMode, fontSize: fontSize)
        }
        .padding(.horizontal, 16)
    }
    
    private var valoresModernoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nuestros Valores")
                .font(.system(size: fontSize + 2, weight: .bold))
                .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                .padding(.horizontal, 16)
            
            VStack(spacing: 12) {
                Button(action: { selectedValor = "Pasión" }) {
                    ValorModerno(icon: "heart.fill", titulo: "Pasión", color: .red, isDarkMode: themeManager.isDarkMode)
                }
                
                Button(action: { selectedValor = "Innovación" }) {
                    ValorModerno(icon: "sparkles", titulo: "Innovación", color: .orange, isDarkMode: themeManager.isDarkMode)
                }
                
                Button(action: { selectedValor = "Colaboración" }) {
                    ValorModerno(icon: "person.2.fill", titulo: "Colaboración", color: .blue, isDarkMode: themeManager.isDarkMode)
                }
                
                Button(action: { selectedValor = "Integridad" }) {
                    ValorModerno(icon: "checkmark.circle.fill", titulo: "Integridad", color: .green, isDarkMode: themeManager.isDarkMode)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nuestro Recorrido")
                .font(.system(size: fontSize + 2, weight: .bold))
                .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                TimelineItem(year: "2019", evento: "Inicio del proyecto", isDarkMode: themeManager.isDarkMode, fontSize: fontSize)
                TimelineItem(year: "2021", evento: "Primer lanzamiento oficial", isDarkMode: themeManager.isDarkMode, fontSize: fontSize)
                TimelineItem(year: "2023", evento: "Alcanzamos 10K usuarios", isDarkMode: themeManager.isDarkMode, fontSize: fontSize)
                TimelineItem(year: "2024", evento: "Expansión regional", isDarkMode: themeManager.isDarkMode, fontSize: fontSize)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var ctaSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                    
                    Text("Lunes a Viernes: 9:00 - 18:00")
                        .font(.system(size: fontSize - 1, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    
                    Spacer()
                }
                
                Text("Estamos disponibles para ayudarte")
                    .font(.system(size: fontSize - 2, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.orange.opacity(0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(14)
            
            Text("¿Preguntas o sugerencias? Contáctanos desde la sección de Soporte")
                .font(.system(size: fontSize - 2, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private func openWhatsApp() {
        let phoneNumber = "51951012633"
        let message = "¡Hola! 👋 Me gustaría obtener más información sobre sus productos."
        
        guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let whatsappURL = "https://wa.me/\(phoneNumber)?text=\(encodedMessage)"
        
        guard let url = URL(string: whatsappURL) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct StatCard: View {
    let numero: String
    let titulo: String
    let color: Color
    let isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(numero)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(titulo)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(isDarkMode ? Color(UIColor(white: 0.15, alpha: 1)) : Color.white)
        .cornerRadius(12)
    }
}

struct MisionVisionCard: View {
    let icon: String
    let titulo: String
    let descripcion: String
    let color: Color
    let isDarkMode: Bool
    let fontSize: Double
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(titulo)
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(isDarkMode ? .white : .primary)
                
                Text(descripcion)
                    .font(.system(size: fontSize - 2, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(14)
        .background(isDarkMode ? Color(UIColor(white: 0.15, alpha: 1)) : Color.white)
        .cornerRadius(12)
    }
}

struct ValorModerno: View {
    let icon: String
    let titulo: String
    let color: Color
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(titulo)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isDarkMode ? .white : .primary)
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(12)
        .background(isDarkMode ? Color(UIColor(white: 0.15, alpha: 1)) : Color.white)
        .cornerRadius(10)
    }
}

struct TimelineItem: View {
    let year: String
    let evento: String
    let isDarkMode: Bool
    let fontSize: Double
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 14, height: 14)
                
                Rectangle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 2, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(year)
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(.orange)
                
                Text(evento)
                    .font(.system(size: fontSize - 1, weight: .regular))
                    .foregroundColor(isDarkMode ? .white : .primary)
            }
            
            Spacer()
        }
    }
}

struct DetalleValorView: View {
    let valor: String
    let isDarkMode: Bool
    let fontSize: Double
    let onDismiss: () -> Void
    
    private var detalles: (icon: String, color: Color, descripcion: String) {
        switch valor {
        case "Pasión":
            return ("heart.fill", .red, "Nos apasiona lo que hacemos. Cada proyecto, cada interacción y cada decisión es tomada con dedicación y entusiasmo. Creemos que la pasión es el combustible que impulsa la innovación y la excelencia en todo lo que hacemos.")
        case "Innovación":
            return ("sparkles", .orange, "Buscamos constantemente nuevas formas de mejorar y evolucionar. La innovación no es solo una palabra para nosotros, es parte de nuestra ADN. Nos desafiamos a nosotros mismos a pensar diferente y a encontrar soluciones creativas.")
        case "Colaboración":
            return ("person.2.fill", .blue, "Creemos en el poder del trabajo en equipo. La colaboración nos permite combinar diferentes perspectivas y talentos para crear algo extraordinario. Juntos somos más fuertes.")
        case "Integridad":
            return ("checkmark.circle.fill", .green, "Actuamos siempre con honestidad, transparencia y responsabilidad. La integridad es la base de todas nuestras relaciones y decisiones. Hacemos lo correcto, incluso cuando nadie está mirando.")
        default:
            return ("info.circle.fill", .gray, "")
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack(spacing: 20) {
                HStack {
                    Text(valor)
                        .font(.system(size: fontSize + 4, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .primary)
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(detalles.color.opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: detalles.icon)
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(detalles.color)
                    }
                    
                    Text(detalles.descripcion)
                        .font(.system(size: fontSize - 0.5, weight: .regular))
                        .foregroundColor(.gray)
                        .lineSpacing(1.6)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(isDarkMode ? Color(UIColor(white: 0.15, alpha: 1)) : Color.white)
                .cornerRadius(16)
                
                Spacer()
            }
            .padding(20)
            .background(isDarkMode ? Color(UIColor(white: 0.1, alpha: 1)) : Color(UIColor(white: 0.95, alpha: 1)))
            .cornerRadius(20)
            .padding(16)
        }
    }
}

#Preview {
    NavigationStack {
        SobreNosotrosView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
