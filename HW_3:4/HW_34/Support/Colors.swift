//
//  Colors.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 12.01.25.
//

import UIKit

class Colors {
    static let backgroud: UIColor! = .init(hex: "242A32")
    static let secondaryBG: UIColor! = .init(hex: "67686D")
}

extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let r, g, b, a: CGFloat
        
        switch hexString.count {
        case 3:
            r = CGFloat((rgb >> 8) & 0xF) / 15.0
            g = CGFloat((rgb >> 4) & 0xF) / 15.0
            b = CGFloat(rgb & 0xF) / 15.0
            a = 1.0
        case 6:
            r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            b = CGFloat(rgb & 0xFF) / 255.0
            a = 1.0
        case 8:
            r = CGFloat((rgb >> 24) & 0xFF) / 255.0
            g = CGFloat((rgb >> 16) & 0xFF) / 255.0
            b = CGFloat((rgb >> 8) & 0xFF) / 255.0
            a = CGFloat(rgb & 0xFF) / 255.0
        default:
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}



