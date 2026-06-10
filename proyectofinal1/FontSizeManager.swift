import SwiftUI

// MARK: - Font Size Manager
final class DemoFontSizeManager: ObservableObject {
    static let shared = DemoFontSizeManager()
    
    @Published var fontSize: Double
    
    // Private init for singleton usage; start with a sensible default
    private init(fontSize: Double = 16) {
        self.fontSize = fontSize
    }
    
    // Presets
    func setSmall() {
        fontSize = 12
    }
    
    func setMedium() {
        fontSize = 16
    }
    
    func setLarge() {
        fontSize = 20
    }
    
    func setXLarge() {
        fontSize = 24
    }
    
    func reset() {
        setMedium()
    }
}

// MARK: - Typography Struct
struct Typography {
    let fontSize: Double
    
    // MARK: - Display Sizes
    var displayLarge: Font {
        .system(size: fontSize * 2.2, weight: .bold)
    }
    
    var displayMedium: Font {
        .system(size: fontSize * 1.8, weight: .bold)
    }
    
    var displaySmall: Font {
        .system(size: fontSize * 1.5, weight: .bold)
    }
    
    // MARK: - Heading Sizes
    var headlineLarge: Font {
        .system(size: fontSize * 1.4, weight: .semibold)
    }
    
    var headlineMedium: Font {
        .system(size: fontSize * 1.2, weight: .semibold)
    }
    
    var headlineSmall: Font {
        .system(size: fontSize * 1.1, weight: .semibold)
    }
    
    // MARK: - Title Sizes
    var titleLarge: Font {
        .system(size: fontSize * 1.3, weight: .semibold)
    }
    
    var titleMedium: Font {
        .system(size: fontSize * 1.15, weight: .semibold)
    }
    
    var titleSmall: Font {
        .system(size: fontSize * 1.05, weight: .semibold)
    }
    
    // MARK: - Body Sizes
    var bodyLarge: Font {
        .system(size: fontSize, weight: .regular)
    }
    
    var bodyMedium: Font {
        .system(size: fontSize * 0.95, weight: .regular)
    }
    
    var bodySmall: Font {
        .system(size: fontSize * 0.9, weight: .regular)
    }
    
    // MARK: - Label Sizes
    var labelLarge: Font {
        .system(size: fontSize * 0.95, weight: .medium)
    }
    
    var labelMedium: Font {
        .system(size: fontSize * 0.85, weight: .medium)
    }
    
    var labelSmall: Font {
        .system(size: fontSize * 0.75, weight: .medium)
    }
    
    // MARK: - Caption Sizes
    var captionLarge: Font {
        .system(size: fontSize * 0.8, weight: .regular)
    }
    
    var captionSmall: Font {
        .system(size: fontSize * 0.7, weight: .regular)
    }
    
    // MARK: - Custom Size
    func custom(size: Double, weight: Font.Weight = .regular) -> Font {
        .system(size: fontSize * (size / 16), weight: weight)
    }
}

// MARK: - Environment Key
struct TypographyKey: EnvironmentKey {
    static let defaultValue = Typography(fontSize: 16)
}

extension EnvironmentValues {
    var typography: Typography {
        get { self[TypographyKey.self] }
        set { self[TypographyKey.self] = newValue }
    }
}

// MARK: - View Extension
extension View {
    func typography(_ fontSize: Double) -> some View {
        environment(\.typography, Typography(fontSize: fontSize))
    }
}

// MARK: - Ejemplo de uso en ContentView
struct ContentViewExample: View {
    @StateObject var fontSizeManager = DemoFontSizeManager.shared
    @Environment(\.typography) var typography
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Display
                VStack(alignment: .leading, spacing: 8) {
                    Text("Display Large")
                        .font(typography.displayLarge)
                    Text("Display Medium")
                        .font(typography.displayMedium)
                    Text("Display Small")
                        .font(typography.displaySmall)
                }
                
                Divider()
                
                // Headings
                VStack(alignment: .leading, spacing: 8) {
                    Text("Headline Large")
                        .font(typography.headlineLarge)
                    Text("Headline Medium")
                        .font(typography.headlineMedium)
                    Text("Headline Small")
                        .font(typography.headlineSmall)
                }
                
                Divider()
                
                // Body
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body Large")
                        .font(typography.bodyLarge)
                    Text("Body Medium")
                        .font(typography.bodyMedium)
                    Text("Body Small")
                        .font(typography.bodySmall)
                }
                
                Divider()
                
                // Caption
                VStack(alignment: .leading, spacing: 8) {
                    Text("Caption Large")
                        .font(typography.captionLarge)
                    Text("Caption Small")
                        .font(typography.captionSmall)
                }
                
                Spacer()
                
                // Font Size Slider
                VStack(spacing: 12) {
                    Text("Tamaño de fuente: \(String(format: "%.0f", fontSizeManager.fontSize))")
                        .font(typography.labelLarge)
                    
                    Slider(value: $fontSizeManager.fontSize, in: 12...24, step: 1)
                        .padding(.horizontal)
                    
                    HStack(spacing: 8) {
                        Button("A-") {
                            fontSizeManager.setSmall()
                        }
                        .font(typography.labelSmall)
                        
                        Button("A") {
                            fontSizeManager.setMedium()
                        }
                        .font(typography.labelMedium)
                        
                        Button("A+") {
                            fontSizeManager.setLarge()
                        }
                        .font(typography.labelLarge)
                        
                        Button("A++") {
                            fontSizeManager.setXLarge()
                        }
                        .font(typography.bodySmall)
                        
                        Spacer()
                        
                        Button("Reset") {
                            fontSizeManager.reset()
                        }
                        .font(typography.labelMedium)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
            .typography(fontSizeManager.fontSize)
            .navigationTitle("Tamaño de Fuente")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentViewExample()
}
