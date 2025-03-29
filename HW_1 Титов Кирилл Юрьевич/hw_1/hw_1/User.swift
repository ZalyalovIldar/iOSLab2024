//
//  User.swift
//  hw_1
//
//  Created by Кирилл Титов on 01.10.2024.
//

import Foundation
import UIKit

struct WorkExperience {
    let year: Int
    let company: String
}

struct User {
    let fullName: String
    let age: Int
    let city: String
    let avatarImage: UIImage?
    let workExperience: [WorkExperience]
}
