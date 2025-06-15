//
//  TaskItemModel.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 7.04.25.
//

import Foundation

struct TaskItem: Storable, Hashable {
    var id: UUID
    var description: String
    var isDone: Bool
    
    init(description: String, isDone: Bool = false) {
        self.id = UUID()
        self.description = description
        self.isDone = isDone
    }

}
