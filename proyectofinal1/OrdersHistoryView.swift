import SwiftUI

struct OrdersHistoryView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    
    @State private var orders: [OrderHistory] = []
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // ✅ Fondo dinámico según el tema
            Color(UIColor { _ in
                themeManager.isDarkMode ? UIColor(white: 0.11, alpha: 1) : .systemBackground
            })
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Toolbar personalizado
                HStack {
                    Spacer()
                    
                    Text(localizationManager.translate("orders.title"))
                        .font(.system(size: fontSize + 1, weight: .semibold))
                        .foregroundStyle(themeManager.isDarkMode ? .white : .black)
                    
                    Spacer()
                }
                .frame(height: 56)
                .background(Color(UIColor { _ in
                    themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .systemBackground
                }))
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text(localizationManager.translate("common.loading"))
                            .foregroundColor(.gray)
                            .padding(.top)
                    }
                    .frame(maxHeight: .infinity)
                } else if orders.isEmpty {
                    // Estado vacío
                    VStack(spacing: 20) {
                        Image(systemName: "bag.badge.questionmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.4))
                        
                        Text(localizationManager.translate("orders.noOrders"))
                            .font(.system(size: fontSize, weight: .semibold))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        
                        Text(localizationManager.translate("orders.noOrdersDesc"))
                            .font(.system(size: fontSize - 2, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else {
                    // Lista de órdenes
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(orders) { order in
                                OrderCardView(order: order)
                                    .environmentObject(themeManager)
                                    .environmentObject(localizationManager)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            loadOrders()
        }
    }
    
    private func loadOrders() {
        isLoading = true
        
        // Simular órdenes de ejemplo
        // En producción, obtendrías esto de Supabase/API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            orders = [
                OrderHistory(
                    id: "ORD-001",
                    date: "2024-11-08",
                    total: 1099.99,
                    status: "entregada",
                    items: [
                        OrderItemDetail(name: "iPad Pro 12.9\"", quantity: 1, price: 1099.99)
                    ]
                ),
                OrderHistory(
                    id: "ORD-002",
                    date: "2024-11-05",
                    total: 599.00,
                    status: "en_camino",
                    items: [
                        OrderItemDetail(name: "iPad Air", quantity: 1, price: 599.00)
                    ]
                ),
                OrderHistory(
                    id: "ORD-003",
                    date: "2024-11-01",
                    total: 1899.99,
                    status: "procesando",
                    items: [
                        OrderItemDetail(name: "MacBook Pro", quantity: 1, price: 1899.99)
                    ]
                )
            ]
            isLoading = false
        }
    }
}

// MARK: - Order Card View
struct OrderCardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("appFontSize") private var fontSize: Double = 16
    
    let order: OrderHistory
    @State private var isExpanded = false
    
    private var statusColor: Color {
        switch order.status {
        case "entregada":
            return .green
        case "en_camino":
            return .blue
        case "procesando":
            return .orange
        case "cancelada":
            return .red
        default:
            return .gray
        }
    }
    
    private var statusLabel: String {
        switch order.status {
        case "entregada":
            return localizationManager.translate("orders.delivered")
        case "en_camino":
            return localizationManager.translate("orders.shipped")
        case "procesando":
            return localizationManager.translate("orders.processing")
        case "cancelada":
            return localizationManager.translate("orders.cancelled")
        default:
            return order.status
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.id)
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                    
                    Text(order.date)
                        .font(.system(size: fontSize - 3, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "$%.2f", order.total))
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(.green)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 6, height: 6)
                        
                        Text(statusLabel)
                            .font(.system(size: fontSize - 3, weight: .regular))
                            .foregroundColor(statusColor)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Items
            VStack(alignment: .leading, spacing: 8) {
                ForEach(order.items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: fontSize - 2, weight: .regular))
                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            
                            Text("x\(item.quantity)")
                                .font(.system(size: fontSize - 4, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", item.price))
                            .font(.system(size: fontSize - 2, weight: .semibold))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                    }
                }
            }
            
            // Expand button
            if order.items.count > 1 {
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    HStack {
                        Text(isExpanded ? "Ver menos" : "Ver más detalles")
                            .font(.system(size: fontSize - 3, weight: .medium))
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor { _ in
            themeManager.isDarkMode ? UIColor(white: 0.15, alpha: 1) : .white
        }))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(themeManager.isDarkMode ? 0.2 : 0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Models
struct OrderHistory: Identifiable {
    let id: String
    let date: String
    let total: Double
    let status: String
    let items: [OrderItemDetail]
}

struct OrderItemDetail: Identifiable {
    let id = UUID()
    let name: String
    let quantity: Int
    let price: Double
}

// MARK: - Preview
#Preview {
    OrdersHistoryView()
        .environmentObject(CartManager())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
