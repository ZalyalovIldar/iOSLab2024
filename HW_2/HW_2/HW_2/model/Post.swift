//
//  User.swift
//  HW_1
//
//  Created by Damir Rakhmatullin on 3.10.24.
//

import Foundation
import UIKit

struct Post: Hashable, Identifiable {
    let id: UUID
    let date: Date
    let title: String?
    let text: String?
    let images: [UIImage]?
}
