import Foundation

struct TaskCellViewModel {
    private let task: TaskItem
    
    var id: UUID {
        return task.id
    }
    
    var title: String {
        return task.title
    }
    
    var isCompleted: Bool {
        return task.isCompleted
    }
    
    init(task: TaskItem) {
        self.task = task
    }
}

