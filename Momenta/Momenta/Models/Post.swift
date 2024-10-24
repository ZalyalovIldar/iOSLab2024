//
//  Post.swift
//  Momenta
//
//  Created by Тагир Файрушин on 16.10.2024.
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
