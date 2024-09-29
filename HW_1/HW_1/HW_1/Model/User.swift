//
//  UserModel.swift
//  HW_1
//
//  Created by Павел Калинин on 21.09.2024.
//

import Foundation

struct User {
    let avatar: String
    let name: String
    let age: Int
    let city: String
    let experience: [Experience]
    let photos: [String]
}

struct Experience {
    let year: String
    let description: String
}
