import SwiftUI
import UIKit

/// Color tokens ported from the validated mockup's CSS custom properties.
/// Defined as dynamic colors (rather than Assets.xcassets color sets) so the light
/// and dark values sit next to each other in one readable place.
enum Palette {
    static let bg = dynamic(light: "EDEAE2", dark: "131211")
    static let surface = dynamic(light: "F7F5EF", dark: "1B1A18")
    static let ink = dynamic(light: "1E1C19", dark: "EDE9E1")
    static let inkSoft = dynamic(light: "6B6558", dark: "A39C8B")
    static let inkFaint = dynamic(light: "A39C8B", dark: "6B6558")
    static let indigo = dynamic(light: "3B4A8C", dark: "8B9AE3")
    static let indigoStrong = dynamic(light: "2C3970", dark: "AAB6EE")
    static let indigoSoft = dynamic(light: "DADFF2", dark: "2A2E4A")
    static let rule = dynamic(light: "DDD8CC", dark: "322F2A")

    private static func dynamic(light: String, dark: String) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

private extension UIColor {
    convenience init(hex: String) {
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)
        let r = CGFloat((value >> 16) & 0xFF) / 255
        let g = CGFloat((value >> 8) & 0xFF) / 255
        let b = CGFloat(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
