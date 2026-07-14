import SwiftUI

struct RepairDetailView: View {
    let part: RepairPart
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("appFontSize") private var fontSize: Double = 16

    var body: some View {
        ZStack {
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            })
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Icono principal
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor { _ in
                                themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : UIColor(white: 0.95, alpha: 1)
                            }))
                            .frame(width: 180, height: 180)

                        Image(systemName: part.icon)
                            .font(.system(size: 70, weight: .medium))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    }
                    .padding(.top, 8)

                    // MARK: - Nombre y badge
                    VStack(spacing: 8) {
                        Text(part.name)
                            .font(.system(size: fontSize + 4, weight: .bold))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                            .multilineTextAlignment(.center)

                        Text(part.stock ? "Disponible" : "Agotado")
                            .font(.system(size: fontSize - 4, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(part.stock ? Color.green : Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)

                    // MARK: - Precio destacado
                    VStack(spacing: 4) {
                        Text("Precio de reparación")
                            .font(.system(size: fontSize - 3))
                            .foregroundStyle(.gray)
                        Text(String(format: "S/ %.2f", part.price))
                            .font(.system(size: fontSize + 10, weight: .bold))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color(UIColor { _ in
                        themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
                    }))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(themeManager.isDarkMode ? 0.2 : 0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    // MARK: - Info cards
                    VStack(spacing: 12) {

                        infoRow(
                            icon: "clock.fill",
                            title: "Tiempo estimado",
                            value: part.repairTime,
                            color: .blue
                        )

                        infoRow(
                            icon: "checkmark.shield.fill",
                            title: "Garantía",
                            value: "90 días en mano de obra",
                            color: .green
                        )

                        infoRow(
                            icon: "bolt.fill",
                            title: "Repuesto",
                            value: "Original Apple",
                            color: .orange
                        )

                        infoRow(
                            icon: "iphone.gen3",
                            title: "Compatible con",
                            value: part.compatibleModels.joined(separator: ", "),
                            color: .purple
                        )
                    }
                    .padding(.horizontal, 16)

                    // MARK: - Descripción
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Descripción")
                            .font(.system(size: fontSize, weight: .semibold))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                        Text(part.description)
                            .font(.system(size: fontSize - 2))
                            .foregroundStyle(.gray)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(UIColor { _ in
                        themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
                    }))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(themeManager.isDarkMode ? 0.2 : 0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    // MARK: - Botón de contacto
                    Button(action: {
                        let phoneNumber = "51951012633" // +51 951 012 633
                        let message = "Hola, me interesa el servicio de reparación: \(part.name)"
                        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message
                        if let url = URL(string: "https://wa.me/\(phoneNumber)?text=\(encodedMessage)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Solicitar reparación")
                                .font(.system(size: fontSize, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle(part.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Info row helper
    private func infoRow(icon: String, title: String, value: String, color: Color) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: fontSize - 4))
                    .foregroundStyle(.gray)
                Text(value)
                    .font(.system(size: fontSize - 2, weight: .semibold))
                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(14)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
        }))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(themeManager.isDarkMode ? 0.2 : 0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    NavigationStack {
        RepairDetailView(part: RepairPart(
            name: "Pantalla iPhone 16 Pro",
            price: 2100,
            description: "Pantalla OLED original con digitalizador tacil.",
            compatibleModels: ["iPhone 16 Pro"],
            repairTime: "45-60 min",
            stock: true,
            imageName: "iphone1"
        ))
        .environmentObject(ThemeManager())
    }
}
