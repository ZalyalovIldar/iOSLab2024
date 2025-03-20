//
//  Colors.swift
//  mathHW
//
//  Created by Данил Забинский on 09.11.2024.
//

import Foundation
import UIKit

class Colors {
    static let mainGray: UIColor! = .init(hex: "242A32")
    static let lighterGray: UIColor! = .init(hex: "67686D")
    static let ratingBGColor: UIColor! = .init(hex: "252836")
    static let lightBlue: UIColor! = .init(hex: "5C80BC")
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
