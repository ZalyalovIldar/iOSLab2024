//
//  TaskViewModel.swift
//  hw2.2
//
//  Created by Кирилл Титов on 11.04.2025.
//

import Foundation

class TaskViewModel<Storage: StorageServiceProtocol> where Storage.Item == TaskItem {
    private let storageService: Storage
    private(set) var tasks: [TaskItem] = []
    
    var onTasksUpdated: (() -> Void)?
    
    init(storageService: Storage) {
        self.storageService = storageService
        loadTasks()
    }
    
    func loadTasks() {
        do {
            tasks = try storageService.load() 
            onTasksUpdated?()
        } catch {
            print("Error loading tasks: \(error)")
        }
    }
    
    func addTask(title: String) {
        let newTask = TaskItem(title: title)
        tasks.append(newTask)
        do {
            try storageService.save(tasks)
            onTasksUpdated?()
        } catch {
            print("Error saving task: \(error)")
        }
    }
    
    func toggleTaskCompletion(at index: Int) {
        guard index < tasks.count else { return }
        var task = tasks[index]
        task.isCompleted.toggle()
        tasks[index] = task
        do {
            try storageService.update(task)
            onTasksUpdated?()
        } catch {
            print("Error updating task: \(error)")
        }
    }
    
    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks.remove(at: index)
        do {
            try storageService.delete(task)
            onTasksUpdated?()
        } catch {
            print("Error deleting task: \(error)")
        }
    }
}
