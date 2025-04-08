//
//  Padding.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

enum Padding {
    
    case tiny, `default`, big
    
    var value: CGFloat {
        switch self {
        case .tiny:
            5
        case .default:
            10
        case .big:
            20
        }
    }
}
