//
//  Post.swift
//  HW2
//
//  Created by Терёхин Иван on 22.10.2024.
//

import Foundation
import UIKit

struct Post: Hashable, Identifiable {
    
    let id: UUID
    let title: String
    let text: String
    let data: Date
    let photos: [UIImage]
    
    static func createData(with date: Date) -> String{
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM/yy HH:mm"
        let current = formater.string(from: date)
        return current
    }
    
}
