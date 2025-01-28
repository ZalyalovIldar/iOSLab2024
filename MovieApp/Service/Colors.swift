import Foundation
import UIKit
class Colors {
    static let mainGray: UIColor! = .init(hex: "242A32")
    static let lighterGray: UIColor! = .init(hex: "67686D")
    static let dark: UIColor! = .init(hex: "252836")
    static let mildPink: UIColor! = .init(hex: "E98A9E")
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
