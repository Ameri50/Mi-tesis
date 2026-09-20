import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var fontSizeManager: AppFontSizeManager

    @State private var tabSelection = 0
    @State private var showCart = false
    @State private var showSettings = false
    @State private var showWelcome = false

    var body: some View {
        ZStack {
            Color.clear
        }
        .appLiquidGlassSurface(enabled: themeManager.isLiquidGlassEnabled, darkMode: themeManager.isDarkMode)
        .overlay {
            if !userManager.isAuthenticated {
                LoginView()
                    .environmentObject(userManager)
                    .transition(.opacity)
            } else {
                ZStack {
                    NavigationStack {
                        VStack(spacing: 0) {
                            TabView(selection: $tabSelection) {
                                // Home
                                NavigationStack {
                                    HomeView()
                                        .environmentObject(cartManager)
                                        .environmentObject(themeManager)
                                        .environmentObject(fontSizeManager)
                                }
                                .tabItem {
                                    Label(localizationManager.translate("common.home"), systemImage: "house.fill")
                                }
                                .tag(0)

                                // Shop
                                NavigationStack {
                                    CategoryView()
                                        .environmentObject(cartManager)
                                        .environmentObject(themeManager)
                                        .environmentObject(fontSizeManager)
                                }
                                .tabItem {
                                    Label(localizationManager.translate("common.shop"), systemImage: "bag.fill")
                                }
                                .tag(1)

                                // Support
                                NavigationStack {
                                    SupportHubView()
                                        .environmentObject(themeManager)
                                        .environmentObject(localizationManager)
                                        .environmentObject(cartManager)
                                }
                                .tabItem {
                                    Label(localizationManager.translate("support.title"), systemImage: "sparkles")
                                }
                                .tag(2)

                                // About
                                NavigationStack {
                                    SobreNosotrosView()
                                        .environmentObject(themeManager)
                                }
                                .tabItem {
                                    Label(localizationManager.translate("common.about"), systemImage: "info.circle.fill")
                                }
                                .tag(3)

                                // Profile
                                NavigationStack {
                                    CrearPerfilView()
                                        .environmentObject(userManager)
                                        .environmentObject(themeManager)
                                }
                                .tabItem {
                                    Label(localizationManager.translate("common.profile"), systemImage: "person.fill")
                                }
                                .tag(4)
                            }
                            .accentColor(themeManager.isDarkMode ? .white : .black)
                        }
                        .navigationDestination(isPresented: $showCart) {
                            CartView()
                                .environmentObject(themeManager)
                                .environmentObject(localizationManager)
                                .environmentObject(fontSizeManager)
                                .environmentObject(cartManager)
                        }
                    }

                    if showWelcome {
                        VStack {
                            Spacer()
                            Text(localizationManager.translate("common.welcomeBack")
                                 + (userManager.currentUser?.name.isEmpty == false ? ", \(userManager.currentUser!.name)!" : "!"))
                                .font(.system(size: 24, weight: .semibold))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(themeManager.isDarkMode ? Color.white.opacity(0.15) : Color.black.opacity(0.15))
                                )
                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                .shadow(radius: 10)
                                .transition(.opacity)
                            Spacer().frame(height: 50)
                        }
                        .zIndex(1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showWelcome = false
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    if !showWelcome {
                        DispatchQueue.main.async {
                            withAnimation(.easeIn) {
                                showWelcome = true
                            }
                        }
                    }
                }
            }
        }
        .environment(\.locale, Locale(identifier: localizationManager.currentLanguage))
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CartManager())
            .environmentObject(UserManager())
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
            .environmentObject(AppFontSizeManager.shared)
    }
}
