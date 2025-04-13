//
//  TaskItem.swift
//  GenericMVVM
//
//  Created by Anna on 13.04.2025.
//

import Foundation

struct TaskItem: Storable {
    let id: String
    var title: String
    var isCompleted: Bool
    let createdAt: Date
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}
