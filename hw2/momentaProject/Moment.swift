//
//  Moment.swift
//  momentaProject
//
//  Created by Данил Забинский on 16.10.2024.
//

import Foundation
import UIKit

struct Moment: Hashable, Identifiable {
    let id: UUID
    let autorsAvatar: UIImage
    let title: String
    let date: /*String*/ Date
    let description: String?
    let photos: [UIImage]?
}
