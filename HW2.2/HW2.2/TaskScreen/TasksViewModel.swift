//
//  TasksViewModel.swift
//  HW2.2
//
//  Created by Павел on 10.04.2025.
//

import Foundation

final class TasksViewModel {
    
    var tasks: [TaskItem] = [] {
        didSet {
            onTasksUpdated?()
        }
    }
    private let storageService: StorageServiceProtocol
    private let storageKey = "tasksKey"
    var onTasksUpdated: (() -> Void)?
    
    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
        loadTasks()
    }
    
    func createTask(with task: String) {
        let newTask = TaskItem(id: UUID(), task: task, date: Date.now, isCompleted: false)
        tasks.append(newTask)
        storageService.save(tasks, storageKey: storageKey)
    }
    
    func loadTasks() {
        tasks = storageService.load(storageKey: storageKey)
    }
     
    func updateCompletionOfTask(with index: Int) {
        tasks[index].isCompleted.toggle()
        storageService.update(tasks[index], storageKey: storageKey)
    }
    
    func deleteTask(task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks.remove(at: index)
        storageService.delete(task, storageKey: storageKey)
    }
    
    
    
}
