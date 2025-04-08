//
//  TaskViewModel.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import Foundation

final class TaskViewModel {
    private(set) var taskData: [TaskItem] = []
    private var storageService: StorageService<TaskItem>
    
    var updateItem: ((TaskItem) -> Void)?
    var removeItem: ((TaskItem) -> Void)?
     
    init(storageService: StorageService<TaskItem>) {
        self.storageService = storageService
        
        let data = getTaskData()
        switch data {
        case .success(let items):
            taskData = items
        case .failure(let error):
            print(error)
        }
    }
    
    func getTaskData() -> Result<[TaskItem], StorageError> {
        if let items = try? storageService.getAll() {
            return .success(items)
        } else {
            return .failure(StorageError.decodingFailed)
        }
    }
    
    func saveData() {
        do {
            try storageService.saveItems(taskData)
        } catch {
            print(error)
        }
    }
    
    func addTask(task: TaskItem) {
        taskData.append(task)
        updateItem?(task)
    }
    
    func removeTask(task: TaskItem) {
        taskData.removeAll(where: { task.id == $0.id })
        removeItem?(task)
    }
}
