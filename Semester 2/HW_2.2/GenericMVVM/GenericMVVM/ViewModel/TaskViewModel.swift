//
//  TaskViewModel.swift
//  GenericMVVM
//
//  Created by Anna on 13.04.2025.
//

import Foundation
class TaskViewModel {
    private let storageService: any StorageServiceProtocol<TaskItem>
    private(set) var tasks: [TaskItem] = []
    
    var onTasksUpdated: (() -> Void)?
    
    init(storageService: any StorageServiceProtocol<TaskItem> = StorageService<TaskItem>(storageKey: "tasks")) {
        self.storageService = storageService
        loadTasks()
    }
    
    func loadTasks() {
        tasks = storageService.fetchAll().sorted { $0.createdAt > $1.createdAt }
        onTasksUpdated?()
    }
    
    func addTask(title: String) {
        let newTask = TaskItem(title: title)
        storageService.save(newTask)
        loadTasks()
    }
    
    func toggleTaskCompletion(_ task: TaskItem) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        storageService.update(updatedTask)
        loadTasks()
    }
    
    func deleteTask(_ task: TaskItem) {
        storageService.delete(task)
        loadTasks()
    }
}
