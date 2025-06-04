//
//  TaskItem.swift
//  HW2.2
//
//  Created by Павел on 10.04.2025.
//

import Foundation

protocol Savable: Codable, Hashable, Identifiable {}

struct TaskItem: Savable {
    let id: UUID
    let task: String
    let date: Date
    var isCompleted: Bool
}
