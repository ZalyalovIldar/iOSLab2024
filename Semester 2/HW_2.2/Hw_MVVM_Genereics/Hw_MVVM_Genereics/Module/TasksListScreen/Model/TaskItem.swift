//
//  Task.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import Foundation

struct TaskItem: Savable, Codable {    
    var id: UUID
    let title: String
    let taskDescription: String
    var isCompleted: Bool
    let date: Date
    
    init(id: UUID = UUID() ,title: String, taskDescription: String, isCompleted: Bool = false,
         date: Date = Date()) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.isCompleted = isCompleted
        self.date = date
    }
}
