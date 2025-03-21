//
//  Post.swift
//  MyMoment
//
//  Created by Павел on 16.10.2024.
//

import Foundation
import UIKit

struct Post: Hashable {
    let id: UUID
    let title: String
    let date: Date
    let text: String
    let photos: [UIImage]
}
