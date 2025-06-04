//
//  User.swift
//  homeWork1
//
//  Created by Данил Забинский on 24.09.2024.
//

import Foundation
import UIKit

struct User {
    let avatarImage: UIImage?
    let fullName: String
    let age: Int
    let currentCity: String
    let experience: [WorkPlace]
    let information: [UIImage]
}


struct WorkPlace {
    let yearOfHire: Int
    let yearOfRelease: Int
    let description: String
    
    func getDescription() -> String {
        return "\(yearOfHire) - \(yearOfRelease): \(description)"
    }
}

extension User {
    var getExperienceSummary: String {
        return experience.map { "• " + $0.getDescription() }.joined(separator: "\n")
    }
}



