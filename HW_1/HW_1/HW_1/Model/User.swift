//
//  User.swift
//  HW_1
//
//  Created by Damir Rakhmatullin on 3.10.24.
//

import Foundation
import UIKit

struct User {
    let name: String
    let age: Int
    let city: String
    let avatarImage: UIImage?
    let workExperience: [Experience]
    let profilePhotos: [UIImage?]
    
}

struct Experience {
    let year: Int
    let experienceDescription: String
}
