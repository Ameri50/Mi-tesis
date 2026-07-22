import SwiftUI

struct CartProductRowView: View {
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
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
}
