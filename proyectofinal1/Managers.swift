import SwiftUI
import Foundation

// MARK: - FontSizeManager
class FontSizeManager: ObservableObject {
    @AppStorage("fontSize") var fontSize: Double = 16
    
    var scale: CGFloat {
        CGFloat(fontSize) / 16.0
    }
}

// MARK: - DynamicFonts
struct DynamicFonts {
    @AppStorage("fontSize") static var fontSize: Double = 16
    
    static var scale: CGFloat {
        CGFloat(fontSize) / 16.0
    }
    
    static var title: Font {
        .system(size: 28 * scale, weight: .bold)
    }
    
    static var title2: Font {
        .system(size: 22 * scale, weight: .semibold)
    }
    
    static var title3: Font {
        .system(size: 20 * scale, weight: .semibold)
    }
    
    static var headline: Font {
        .system(size: 18 * scale, weight: .semibold)
    }
    
    static var body: Font {
        .system(size: 16 * scale, weight: .regular)
    }
    
    static var subheadline: Font {
        .system(size: 14 * scale, weight: .regular)
    }
    
    static var caption: Font {
        .system(size: 12 * scale, weight: .regular)
    }
    
    static var caption2: Font {
        .system(size: 11 * scale, weight: .regular)
    }
}
