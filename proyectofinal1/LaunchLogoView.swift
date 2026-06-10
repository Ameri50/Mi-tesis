import SwiftUI

struct LaunchLogoView: View {
    @State private var appear = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            Image("AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                .accessibility(hidden: true)
                .scaleEffect(appear ? 1.0 : 0.90)
                .opacity(appear ? 1.0 : 0.0)
                .animation(.spring(response: 0.7, dampingFraction: 0.85, blendDuration: 0.2), value: appear)
        }
        .onAppear { appear = true }
    }
}

#Preview {
    LaunchLogoView()
}
