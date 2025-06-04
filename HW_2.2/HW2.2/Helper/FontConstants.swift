//
//  FontConstants.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

enum FontConstants {
    
    case tiny, `default`, title, header
    
    var value: CGFloat {
        switch self {
        case .tiny:
            12
        case .default:
            16
        case .title:
            22
        case .header:
            32
        }
    }
}
