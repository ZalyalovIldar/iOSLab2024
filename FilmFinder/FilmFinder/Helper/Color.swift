//
//  Color.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import Foundation
import UIKit

struct Color {
    static let backgroundColor = UIColor(hex: "242A32")
    static let customDarkGrey = UIColor(hex: "3A3F47")
    static let textFieldTextColor = UIColor(hex: "67686D")
    static let tabBarIconColor = UIColor(hex: "0296E5")
    static let customGrey = UIColor(hex: "92929D")
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
