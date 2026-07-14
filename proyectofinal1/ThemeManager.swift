import SwiftUI
import Foundation

// MARK: - Enumeración de Temas
enum ThemeMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    var displayName: String {
        switch self {
        case .light: return "Claro"
        case .dark: return "Oscuro"
        case .auto: return "Automático"
        }
    }
}

// MARK: - ThemeManager
class ThemeManager: NSObject, ObservableObject {
    @Published var currentThemeMode: ThemeMode = .auto
    @Published var isDarkMode: Bool = false
    @Published var currentTime: String = ""
    @Published var dayPeriod: String = ""
    
    private var timer: Timer?
    
    override init() {
        super.init()
        self.currentThemeMode = loadThemeMode()
        self.isDarkMode = shouldUseDarkMode()
        self.currentTime = getCurrentTimeFormatted()
        self.dayPeriod = getDayPeriodText()
        
        startTimer()
    }
    
    func setThemeMode(_ mode: ThemeMode) {
        currentThemeMode = mode
        saveThemeMode(mode)
        updateDarkMode()
    }
    
    private func updateDarkMode() {
        DispatchQueue.main.async {
            self.isDarkMode = self.shouldUseDarkMode()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.currentTime = self?.getCurrentTimeFormatted() ?? ""
                self?.dayPeriod = self?.getDayPeriodText() ?? ""
                if self?.currentThemeMode == .auto {
                    self?.updateDarkMode()
                }
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Theme Logic
    
    private func shouldUseDarkMode() -> Bool {
        switch currentThemeMode {
        case .light:
            return false
        case .dark:
            return true
        case .auto:
            return isNightTime()
        }
    }
    
    private func isNightTime() -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        return hour >= 18 || hour < 6
    }
    
    // MARK: - Time Formatting
    
    private func getCurrentTimeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    private func getDayPeriodText() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 0..<6:
            return "Madrugada"
        case 6..<12:
            return "Mañana"
        case 12..<18:
            return "Tarde"
        default:
            return "Noche"
        }
    }
    
    // MARK: - UserDefaults Persistence
    
    private func loadThemeMode() -> ThemeMode {
        if let saved = UserDefaults.standard.string(forKey: "themeMode"),
           let mode = ThemeMode(rawValue: saved) {
            return mode
        }
        return .auto
    }
    
    private func saveThemeMode(_ mode: ThemeMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: "themeMode")
        UserDefaults.standard.synchronize()
    }
}
