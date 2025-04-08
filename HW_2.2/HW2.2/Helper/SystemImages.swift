//
//  SystemImages.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

enum SystemImages {
    
    case square, addTodo
    
    var image: UIImage {
        switch self {
        case .square:
            UIImage(systemName: "square")!
        case .addTodo:
            UIImage(systemName: "plus.circle.fill")!
        }
    }
}
