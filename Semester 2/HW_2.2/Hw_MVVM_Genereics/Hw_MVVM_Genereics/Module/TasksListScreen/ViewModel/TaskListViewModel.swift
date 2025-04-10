//
//  TaskListViewModel.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import Foundation

class TaskListViewModel {
    private let storage: any StorageServiceProtocol<TaskItem, UserDefaultsError>
    var items: [TaskItem] = [] {
        didSet {
            onItemsUpdated?()
        }
    }
    
    var onItemsUpdated: (() -> Void)?
    
    init(storage: any StorageServiceProtocol<TaskItem,
         UserDefaultsError> = UserDefaultsStorageService<TaskItem>()) {
        self.storage = storage
        loadTask()
    }
    
    private func loadTask() {
        let result = storage.fetch()
        switch result {
        case .success(let data):
            items = data
        case .failure(let error):
            print("Error obtain data: \(error)")
        }
    }
    
    func deleteTask(by id: UUID) {
        switch storage.deleteBy(id: id) {
        case .success: loadTask()
        case .failure(let error):
            print("Delete error: \(error)")
        }
    }
    
    func addTask(title: String, description: String) {
        let task = TaskItem(title: title, taskDescription: description)
        items.append(task)
        switch storage.save(items: items) {
        case .success(()): break
        case .failure(let error):
            print("Failed saved \(error)")
        }
    }
    
    private func save() {
        switch storage.save(items: items) {
        case .success(()): break
        case .failure(let error):
            print("Failed saved \(error)")
        }
    }
    
    
    func toggleTaskCompletion(task: TaskItem) {
        if let index = items.firstIndex(where: { $0.id == task.id }) {
            items[index].isCompleted.toggle()
            save()
        }
    }
}


