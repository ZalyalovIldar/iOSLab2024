//
//  Todo.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

struct Todo: Storable {
    var id: UUID
    
    let title: String
    let isFinished: Bool
}
