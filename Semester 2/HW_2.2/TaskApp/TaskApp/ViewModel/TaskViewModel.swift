import Foundation

class TaskViewModel {
    private let storage: UserDefaultsStorage<TaskItem>
    var tasks: [TaskItem] {
        didSet {
            storage.save(items: tasks)
        }
    }
    
    init(storage: UserDefaultsStorage<TaskItem>) {
        self.storage = storage
        self.tasks = storage.load()
    }
    
    func addTask(title: String) {
        let newTask = TaskItem(id: UUID(), title: title, isCompleted: false)
        tasks.append(newTask)
    }
    
    func toggleTaskCompletion(at index: Int) {
        if index >= 0 && index < tasks.count {
            tasks[index].isCompleted.toggle()
        }
    }
}
