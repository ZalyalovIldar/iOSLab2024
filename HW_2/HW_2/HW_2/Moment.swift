//
//  Moment.swift
//  HW_2
//
//  Created by Павел Калинин on 20.10.2024.
//



import Foundation
import UIKit

struct Moment: Hashable, Identifiable {
    var id: UUID
    var date: Date
    var images: [UIImage]
    var description: String
}
