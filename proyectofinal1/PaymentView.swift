import SwiftUI
import FirebaseFirestore

// MARK: - ⚙️ CONFIGURACIÓN DE PAGO — Edita solo esta sección
// ============================================================
struct PaymentConfig {
    // Yape
    static let yapeNombre      = "Tu Nombre Aquí"
    static let yapeNumero      = "+51 9XX XXX XXX"

    // Interbank
    static let ibNombre        = "Tu Nombre Aquí"
    static let ibCuenta        = "XXX-XXXXXXX-X-XX"
    static let ibCCI           = "003-XXX-XXXXXXXXXX-XX"

    // WhatsApp
    static let whatsappNumero  = "51997609045"
}
// ============================================================

// MARK: - PaymentView
struct PaymentView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    @State private var selectedMethod: PaymentMethod? = nil
    @State private var showSuccess = false

    enum PaymentMethod { case yape, interbank, card }

    private var bg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.07, alpha: 1)
                : UIColor(white: 0.96, alpha: 1)
        })
    }

    private var cardBg: Color {
        Color(UIColor { _ in
            themeManager.isDarkMode
                ? UIColor(white: 0.12, alpha: 1)
                : UIColor(white: 1.0, alpha: 1)
        })
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: Resumen
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Resumen del pedido")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)

                        ForEach(cartManager.cartItems) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.product.name)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                                    Text("\(item.selectedColor) · \(item.selectedStorage) · x\(item.quantity)")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text("S/ \(String(format: "%.2f", item.totalPrice))")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                            }
                            Divider()
                        }

                        HStack {
                            Text("Total")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                            Spacer()
                            Text("S/ \(String(format: "%.2f", cartManager.totalPrice))")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(18)
                    .background(cardBg)
                    .cornerRadius(18)

                    // MARK: Métodos de pago
                    Text("Elige cómo pagar")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)

                    PaymentMethodButton(
                        label: "Pagar con Yape",
                        subtitle: "Rápido y sin comisión",
                        color: Color(red: 0.42, green: 0.13, blue: 0.66),
                        icon: "Y"
                    ) {
                        withAnimation(.spring(response: 0.3)) { selectedMethod = .yape }
                    }

                    PaymentMethodButton(
                        label: "Transferencia Interbank",
                        subtitle: "Cuenta o CCI",
                        color: Color(red: 0.0, green: 0.24, blue: 0.65),
                        icon: "IB"
                    ) {
                        withAnimation(.spring(response: 0.3)) { selectedMethod = .interbank }
                    }

                    PaymentMethodButton(
                        label: "Tarjeta de crédito/débito",
                        subtitle: "Visa, Mastercard · vía Culqi",
                        color: Color(red: 0.11, green: 0.11, blue: 0.12),
                        icon: "💳"
                    ) {
                        withAnimation(.spring(response: 0.3)) { selectedMethod = .card }
                    }
                }
                .padding(16)
            }

            // MARK: Sheet Yape
            if selectedMethod == .yape {
                PaymentSheet(color: Color(red: 0.42, green: 0.13, blue: 0.66)) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Pagar con Yape")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                            .padding(.bottom, 4)
                        Text("Yapea S/ \(String(format: "%.2f", cartManager.totalPrice)) a este número")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 16)

                        InfoRow(label: "Titular", value: PaymentConfig.yapeNombre)
                        InfoRow(label: "Número Yape", value: PaymentConfig.yapeNumero, copyable: true)
                        InfoRow(label: "Monto exacto",
                                value: "S/ \(String(format: "%.2f", cartManager.totalPrice))",
                                valueColor: Color(red: 0.42, green: 0.13, blue: 0.66))

                        HintBox(text: "Luego de yapear, envía el comprobante por WhatsApp al mismo número.",
                                color: Color(red: 0.42, green: 0.13, blue: 0.66))
                            .padding(.top, 10)

                        Button {
                            openWhatsApp()
                            saveOrder(method: "Yape")
                            withAnimation { showSuccess = true }
                        } label: {
                            Text("Ya yapié ✓")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color(red: 0.42, green: 0.13, blue: 0.66))
                                .cornerRadius(14)
                        }
                        .padding(.top, 14)

                        Button { withAnimation { selectedMethod = nil } } label: {
                            Text("Cancelar")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.12))
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                }
            }

            // MARK: Sheet Interbank
            if selectedMethod == .interbank {
                PaymentSheet(color: Color(red: 0.0, green: 0.24, blue: 0.65)) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Transferencia Interbank")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                            .padding(.bottom, 4)
                        Text("Transfiere S/ \(String(format: "%.2f", cartManager.totalPrice)) a esta cuenta")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 16)

                        InfoRow(label: "Titular", value: PaymentConfig.ibNombre)
                        InfoRow(label: "N° de cuenta", value: PaymentConfig.ibCuenta, copyable: true)
                        InfoRow(label: "CCI", value: PaymentConfig.ibCCI, copyable: true)
                        InfoRow(label: "Monto exacto",
                                value: "S/ \(String(format: "%.2f", cartManager.totalPrice))",
                                valueColor: Color(red: 0.0, green: 0.24, blue: 0.65))

                        HintBox(text: "Envía el voucher por WhatsApp para confirmar tu pedido.",
                                color: Color(red: 0.0, green: 0.24, blue: 0.65))
                            .padding(.top, 10)

                        Button {
                            openWhatsApp()
                            saveOrder(method: "Interbank")
                            withAnimation { showSuccess = true }
                        } label: {
                            Text("Ya transferí ✓")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color(red: 0.0, green: 0.24, blue: 0.65))
                                .cornerRadius(14)
                        }
                        .padding(.top, 14)

                        Button { withAnimation { selectedMethod = nil } } label: {
                            Text("Cancelar")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.12))
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                }
            }

            // MARK: Sheet Tarjeta
            if selectedMethod == .card {
                CardPaymentSheet(
                    total: cartManager.totalPrice,
                    themeManager: themeManager,
                    onConfirm: {
                        saveOrder(method: "Tarjeta")
                        withAnimation { showSuccess = true }
                    },
                    onCancel: {
                        withAnimation { selectedMethod = nil }
                    }
                )
            }

            // MARK: Éxito
            if showSuccess {
                SuccessOverlay {
                    cartManager.clearCart()
                    dismiss()
                }
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers
    private func openWhatsApp() {
        var msg = "🛒 *COMPRA - TIENDA APPLE*\n\n"
        for item in cartManager.cartItems {
            msg += "• \(item.product.name) · \(item.selectedColor) · x\(item.quantity) = S/ \(String(format: "%.2f", item.totalPrice))\n"
        }
        msg += "\n💰 Total: S/ \(String(format: "%.2f", cartManager.totalPrice))\n✅ Adjunto mi comprobante."
        guard let encoded = msg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://wa.me/\(PaymentConfig.whatsappNumero)?text=\(encoded)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func saveOrder(method: String) {
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "metodo_pago": method,
            "items": cartManager.cartItems.map {[
                "nombre": $0.product.name,
                "cantidad": $0.quantity,
                "precio": $0.totalPrice,
                "color": $0.selectedColor,
                "storage": $0.selectedStorage
            ]},
            "total": cartManager.totalPrice,
            "estado": "pendiente_confirmacion",
            "fecha": FieldValue.serverTimestamp()
        ]
        db.collection("orders").addDocument(data: data) { error in
            if let error = error { print("❌ Error guardando orden: \(error)") }
            else { print("✅ Orden guardada en Firebase") }
        }
    }
}

// MARK: - Componentes auxiliares

struct PaymentMethodButton: View {
    let label: String
    let subtitle: String
    let color: Color
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Text(icon)
                        .font(.system(size: icon.count > 1 ? 14 : 20, weight: .bold))
                        .foregroundStyle(color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var copyable: Bool = false
    var valueColor: Color = .primary
    @State private var copied = false

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            Spacer()
            Text(copied ? "¡Copiado!" : value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(copied ? .green : valueColor)
            if copyable {
                Button {
                    UIPasteboard.general.string = value
                    withAnimation { copied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copied = false }
                    }
                } label: {
                    Text("Copiar")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 10)
        Divider()
    }
}

struct HintBox: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundStyle(color)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color.opacity(0.08))
            .cornerRadius(10)
    }
}

struct PaymentSheet<Content: View>: View {
    let color: Color
    @ViewBuilder let content: Content

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4).ignoresSafeArea()
                .transition(.opacity)
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.35))
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 14)
                content
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(24)
            .transition(.move(edge: .bottom))
        }
        .ignoresSafeArea()
    }
}

struct CardPaymentSheet: View {
    let total: Double
    let themeManager: ThemeManager
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var cardNumber = ""
    @State private var cardName = ""
    @State private var expiry = ""
    @State private var cvv = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.35))
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 14)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Tarjeta de pago")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)

                    Text("Ingresa los datos de tu tarjeta")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)

                    VStack(spacing: 10) {
                        TextField("Número de tarjeta", text: $cardNumber)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .onChange(of: cardNumber) { _, newValue in
                                let digits = newValue.filter { $0.isNumber }
                                let limited = String(digits.prefix(16))
                                var formatted = ""
                                for (i, c) in limited.enumerated() {
                                    if i > 0 && i % 4 == 0 { formatted += " " }
                                    formatted.append(c)
                                }
                                if formatted != newValue {
                                    cardNumber = formatted
                                }
                            }

                        TextField("Nombre en la tarjeta", text: $cardName)
                            .padding(12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)

                        HStack(spacing: 10) {
                            TextField("MM/AA", text: $expiry)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)

                            TextField("CVV", text: $cvv)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                        Text("Pago seguro · Procesado por Culqi")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }

                    Button(action: onConfirm) {
                        Text("Pagar S/ \(String(format: "%.2f", total))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.black)
                            .cornerRadius(14)
                    }

                    Button(action: onCancel) {
                        Text("Cancelar")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.12))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(24)
            .transition(.move(edge: .bottom))
        }
        .ignoresSafeArea()
    }
}

struct SuccessOverlay: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)
                Text("¡Pago registrado!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                Text("Tu pedido fue guardado.\nTe contactaremos para confirmar.")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                Button(action: onDismiss) {
                    Text("Volver al inicio")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 32)
                .padding(.top, 8)
            }
            .padding(32)
        }
        .transition(.opacity)
    }
}
