import SwiftUI

struct LegalSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct LegalDocumentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    let title: String
    let subtitle: String
    let lastUpdated: String
    let sections: [LegalSection]

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemGroupedBackground
            })
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    ForEach(sections) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.title)
                                .font(.system(size: fontSize + 1, weight: .semibold))
                                .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                            Text(section.body)
                                .font(.system(size: fontSize - 1))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(3)
                        }
                        .padding(16)
                        .background(Color(UIColor { _ in
                            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
                        }))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 28))
                .foregroundColor(.orange)

            Text(subtitle)
                .font(.system(size: fontSize, weight: .regular))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Actualizado: \(lastUpdated)")
                .font(.system(size: fontSize - 3, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.orange.opacity(themeManager.isDarkMode ? 0.24 : 0.16),
                    Color.blue.opacity(themeManager.isDarkMode ? 0.16 : 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        LegalDocumentView(
            title: "Politica de Privacidad",
            subtitle: "Aqui explicamos como tratamos tus datos dentro de la app y cuando usas nuestros servicios.",
            lastUpdated: "31 de julio de 2026",
            sections: [
                LegalSection(
                    title: "Datos que recopilamos",
                    body: "Podemos guardar datos de cuenta, historial de compras, mensajes de soporte y preferencias de la app para hacer que tu experiencia sea mas rapida y personalizada."
                ),
                LegalSection(
                    title: "Uso de la informacion",
                    body: "Usamos la informacion para gestionar tu cuenta, dar soporte, procesar pedidos y mejorar recomendaciones dentro de la aplicacion."
                ),
                LegalSection(
                    title: "Proteccion y seguridad",
                    body: "Aplicamos medidas tecnicas y organizativas para proteger tus datos. No compartimos informacion personal con terceros salvo que sea necesario para prestar el servicio o que tu lo autorices."
                ),
                LegalSection(
                    title: "Contacto",
                    body: "Si quieres revisar, corregir o eliminar informacion asociada a tu cuenta, puedes escribir a soporte@tech.com o usar la seccion de soporte."
                )
            ]
        )
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        LegalDocumentView(
            title: "Terminos de Servicio",
            subtitle: "Estas reglas explican como usar la app, comprar productos y solicitar soporte.",
            lastUpdated: "31 de julio de 2026",
            sections: [
                LegalSection(
                    title: "Aceptacion",
                    body: "Al usar la app aceptas estos terminos y confirmas que la informacion que registras es veraz y que utilizaras la plataforma de forma responsable."
                ),
                LegalSection(
                    title: "Compras y pagos",
                    body: "Los precios, stock y disponibilidad pueden cambiar segun el inventario. Antes de pagar, revisa bien el producto, la configuracion elegida y el total final del pedido."
                ),
                LegalSection(
                    title: "Soporte y servicio",
                    body: "La seccion de soporte te permite abrir el chatbot tecnico o ver recomendaciones de productos. El asesoramiento dentro de la app es orientativo y no reemplaza una evaluacion tecnica presencial cuando hace falta."
                ),
                LegalSection(
                    title: "Cambios",
                    body: "Podemos actualizar estos terminos en cualquier momento para reflejar cambios en el servicio, catalogo o politicas internas. Te recomendamos revisarlos periodicamente."
                )
            ]
        )
    }
}

#Preview("Politica de Privacidad") {
    NavigationStack {
        PrivacyPolicyView()
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
