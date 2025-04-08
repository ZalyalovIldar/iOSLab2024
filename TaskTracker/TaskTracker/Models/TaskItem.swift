//
//  TaskItem.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import Foundation

struct TaskItem: Storable {
    let id: UUID
    let createDate: Date
    let text: String
    
    init(id: UUID = UUID(), createDate: Date = Date(), text: String) {
        self.id = id
        self.createDate = createDate
        self.text = text
    }
}
