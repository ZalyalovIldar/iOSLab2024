//
//  User.swift
//  HW1
//
//  Created by дилара  on 04.10.2024.
//

import Foundation

import UIKit

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

struct Photo {
    let imageName: String
}
