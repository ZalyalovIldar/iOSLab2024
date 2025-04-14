//
//  TaskItem.swift
//  MVVMJen
//
//  Created by Артур Мавликаев on 14.04.2025.
//


import UIKit
import Foundation

protocol StorageProtocol {
    associatedtype Model: Codable
    func save(data: [Model])
    func load() -> [Model]
    
}


struct TaskItem: Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
}
