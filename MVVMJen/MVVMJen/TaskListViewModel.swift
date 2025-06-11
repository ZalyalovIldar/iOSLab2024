//
//  TaskListViewModel.swift
//  MVVMJen
//
//  Created by Артур Мавликаев on 14.04.2025.
//


class TaskListViewModel {
    private var storageService: UserDefaultsStorage<TaskItem>
    private(set) var tasks: [TaskItem] = []

    init(storageService: UserDefaultsStorage<TaskItem> = UserDefaultsStorage<TaskItem>(key: "tasks")) {
        self.storageService = storageService
        self.loadTasks()
    }

    
    func loadTasks() {
        tasks = storageService.load()
    }

    
    func addTask(title: String) {
        let newTask = TaskItem(title: title)
        tasks.append(newTask)
        storageService.save(data: tasks)
    }

    
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
        storageService.save(data: tasks)
    }
}
