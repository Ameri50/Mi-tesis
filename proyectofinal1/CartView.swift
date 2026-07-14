import SwiftUI
import FirebaseFirestore

// Local, unambiguous font sizing for CartView
struct CartFontSizes {
    let title: CGFloat
    let headline: CGFloat
    let body: CGFloat
    let caption: CGFloat

    init(fontSize: Double) {
        let base = CGFloat(fontSize)
        let clamped = max(12, min(base, 30))
        self.title = clamped + 8
        self.headline = clamped + 2
        self.body = clamped
        self.caption = max(10, clamped - 2)
    }
}

// MARK: - Cart View

struct CartView: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToPayment = false

    var body: some View {
        let sizes = CartFontSizes(fontSize: fontSize)

        return NavigationStack {
            ZStack {
                Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
                })
                .ignoresSafeArea()

                if cartManager.isEmpty {
                    emptyCartView(sizes: sizes)
                } else {
                    cartContentView(sizes: sizes)
                }
            }
            .navigationTitle("Carrito")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToPayment) {
                PaymentView()
                    .environmentObject(cartManager)
                    .environmentObject(themeManager)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !cartManager.isEmpty {
                        Button("Limpiar") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                cartManager.clearCart()
                            }
                        }
                        .foregroundColor(.red)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("Información", isPresented: $showAlert) {
                Button("Aceptar") { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func emptyCartView(sizes: CartFontSizes) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.secondary)

            Text("Tu carrito está vacío")
                .font(.system(size: sizes.headline, weight: .medium))
                .foregroundColor(themeManager.isDarkMode ? .white : .primary)

            Text("Agrega algunos productos para comenzar")
                .font(.system(size: sizes.body, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { dismiss() }) {
                Text("Continuar comprando")
                    .font(.system(size: sizes.body, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .frame(maxWidth: 300)
    }

    private func cartContentView(sizes: CartFontSizes) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach($cartManager.cartItems) { $item in
                        CartItemRow(item: $item, sizes: sizes)
                            .environmentObject(themeManager)
                            .environmentObject(cartManager)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }

            cartSummary(sizes: sizes)
        }
    }

    private func cartSummary(sizes: CartFontSizes) -> some View {
        VStack(spacing: 16) {
            Divider()

            VStack(spacing: 8) {
                HStack {
                    Text("Total de productos:")
                        .font(.system(size: sizes.body, weight: .regular))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(cartManager.totalItemsCount)")
                        .font(.system(size: sizes.body, weight: .medium))
                        .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                }

                HStack {
                    Text("Total:")
                        .font(.system(size: sizes.headline, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    Spacer()
                    Text(cartManager.formattedTotalPrice)
                        .font(.system(size: sizes.headline, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .orange : .accentColor)
                }
            }
            .padding(.horizontal)

            VStack(spacing: 12) {
                Button(action: {
                    navigateToPayment = true
                }) {
                    HStack {
                        Image(systemName: "creditcard")
                        Text("Completar Compra")
                            .font(.system(size: sizes.body, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                }

                Button(action: { sendWhatsAppMessage() }) {
                    HStack {
                        Image(systemName: "bubble.right.fill")
                        Text("Enviar por WhatsApp")
                            .font(.system(size: sizes.body, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .secondarySystemBackground
        }))
    }

    private func sendWhatsAppMessage() {
        let phoneNumber = "51951012633"
        var message = "🛒 *NUEVA COMPRA - TIENDA APPLE*\n\n📝 *DETALLES DEL PEDIDO:*\n═══════════════════════════\n\n"
        for (index, item) in cartManager.cartItems.enumerated() {
            message += "📦 *Producto \(index + 1):*\n"
            message += "   • Nombre: \(item.product.name)\n"
            message += "   • Color: \(item.selectedColor)\n"
            message += "   • Capacidad: \(item.selectedStorage)\n"
            message += "   • Cantidad: \(item.quantity) x $\(String(format: "%.2f", item.finalPrice))\n"
            message += "   • Subtotal: $\(String(format: "%.2f", item.totalPrice))\n\n"
        }
        message += "═══════════════════════════\n💰 Total: $\(String(format: "%.2f", cartManager.totalPrice))\n📅 Fecha: \(getCurrentDateTime())\nGracias por tu compra! 🙏"

        guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://wa.me/\(phoneNumber)?text=\(encoded)") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            alertMessage = "WhatsApp no está instalado."
            showAlert = true
        }
    }

    private func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

// MARK: - Cart Item Row

struct CartItemRow: View {
    @AppStorage("appFontSize") private var fontSize: Double = 16
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var cartManager: CartManager

    @Binding var item: CartItemModel
    fileprivate let sizes: CartFontSizes

    var body: some View {
        HStack(spacing: 12) {
            Image(item.product.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor { _ in
                            themeManager.isDarkMode ? UIColor(white: 0.20, alpha: 1) : .systemGray6
                        }))
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 8) {
                Text(item.product.name)
                    .font(.system(size: sizes.headline, weight: .medium))
                    .foregroundColor(themeManager.isDarkMode ? .white : .primary)
                    .lineLimit(2)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Color: \(item.selectedColor)")
                        .font(.system(size: sizes.caption, weight: .regular))
                        .foregroundColor(.secondary)
                    Text("\(item.selectedStorage)")
                        .font(.system(size: sizes.caption, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            cartManager.decrease(item: item)
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.red)
                            .clipShape(Circle())
                    }

                    Text("\(item.quantity)")
                        .font(.system(size: sizes.body, weight: .medium))
                        .frame(minWidth: 28)
                        .foregroundColor(themeManager.isDarkMode ? .white : .primary)

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            cartManager.increase(item: item)
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }

                VStack(spacing: 2) {
                    Text("$\(String(format: "%.2f", item.finalPrice))")
                        .font(.system(size: sizes.caption, weight: .regular))
                        .foregroundColor(.secondary)
                    Text("$\(String(format: "%.2f", item.totalPrice))")
                        .font(.system(size: sizes.caption, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .orange : .accentColor)
                }

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        cartManager.remove(item: item)
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(height: 24)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .tertiarySystemBackground
                }))
                .shadow(color: .black.opacity(themeManager.isDarkMode ? 0.2 : 0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    CartView()
        .environmentObject(CartManager())
        .environmentObject(ThemeManager())
}
