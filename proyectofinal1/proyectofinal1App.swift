import SwiftUI
import FirebaseCore
import FirebaseAppCheck

// MARK: - FontSizeManager
@MainActor
class AppFontSizeManager: ObservableObject {
    @Published var fontSize: Double = 16 {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
            UserDefaults.standard.synchronize()
        }
    }
    
    static let shared = AppFontSizeManager()
    
    init() {
        let saved = UserDefaults.standard.double(forKey: "fontSize")
        self.fontSize = saved > 0 ? saved : 16
    }
    
    func setSmall()  { fontSize = 14 }
    func setMedium() { fontSize = 16 }
    func setLarge()  { fontSize = 18 }
    func setXLarge() { fontSize = 20 }
    func reset()     { fontSize = 16 }
}

// MARK: - Auto Dark Mode por hora
func isDarkModeByHour() -> Bool {
    let hour = Calendar.current.component(.hour, from: Date())
    return hour >= 20 || hour < 7
}

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // ✅ Fix App Check para Simulador
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif

        FirebaseApp.configure()
        return true
    }
}

// MARK: - Main App
@main
struct proyectofinal1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var cartManager        = CartManager()
    @StateObject private var themeManager       = ThemeManager()
    @StateObject private var fontSizeManager    = AppFontSizeManager.shared
    @StateObject private var userManager        = UserManager()
    @StateObject private var localizationManager = LocalizationManager()

    @State private var isInitialized = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !isInitialized {
                    ZStack {
                        Color(.systemBackground)
                            .ignoresSafeArea()

                        Image("LogoApp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                    }
                    .preferredColorScheme(isDarkModeByHour() ? .dark : .light)
                    .onAppear {
                        themeManager.isDarkMode = isDarkModeByHour()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                isInitialized = true
                            }
                        }
                    }
                } else {
                    ContentView()
                        .environmentObject(cartManager)
                        .environmentObject(themeManager)
                        .environmentObject(fontSizeManager)
                        .environmentObject(userManager)
                        .environmentObject(localizationManager)
                        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
                }
            }
        }
    }
}
