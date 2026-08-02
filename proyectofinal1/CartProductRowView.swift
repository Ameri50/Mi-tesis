import SwiftUI

struct CartProductRowView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var cartItem: CartItemModel
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 16) {
            // Imagen del producto
            RemoteOrLocalImage(source: cartItem.product.imageName, contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.name)
                    .font(.headline)
                
                Text("$\(String(format: "%.2f", cartItem.product.price))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
          
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        cartManager.decrease(item: cartItem)
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 28, height: 28)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.headline)
                        .frame(width: 24)
                    
                    Button {
                        cartManager.increase(item: cartItem)
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 28, height: 28)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(String(format: "$%.2f", cartItem.totalPrice))
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
            .padding()
            .appLiquidGlassSurface(
                enabled: themeManager.isLiquidGlassEnabled,
                darkMode: themeManager.isDarkMode,
                cornerRadius: 16
            )
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.12 : 0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
}
