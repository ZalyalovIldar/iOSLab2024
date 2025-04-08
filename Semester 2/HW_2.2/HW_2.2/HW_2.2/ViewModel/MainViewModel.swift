//
//  MainViewModel.swift
//  HW_2.2
//
//  Created by Павел Калинин on 06.04.2025.
//
import Foundation

class MainViewModel {
    private(set) var items: [TaskItem] = [] {
        didSet {
            onTasksUpdated?(items)
        }
    }

    var onTasksUpdated: (([TaskItem]) -> Void)?
    
    private let storage: StorageService
    private let key = "task_items"
    
    init(storage: StorageService = UserDefaultsStorageService()) {
        self.storage = storage
        loadTasks()
    }
    
    func addTask(title: String) {
        let newTask = TaskItem(id: UUID(), title: title, isCompleted: false)
        items.append(newTask)
        storage.save(items, forKey: key)
    }
    
    func loadTasks() {
        items = storage.load(forKey: key)
    }
    
    func toggleTaskCompletion(at index: Int) {
        items[index].isCompleted.toggle()
        storage.update(items[index], forKey: key)
    }
    
    func deleteTask(at index: Int) {
        let task = items[index]
        items.remove(at: index)
        storage.delete(task, forKey: key)
    }
}
