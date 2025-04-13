import Foundation

protocol TaskListViewModelDelegate: AnyObject {
    func tasksDidUpdate()
}

class TaskListViewModel {
    private(set) var tasks: [TaskItem] = [] {
        didSet {
            delegate?.tasksDidUpdate()
        }
    }

    weak var delegate: TaskListViewModelDelegate?

    private let storage: StorageServiceProtocol
    private let storageKey = "tasks"

    init(storage: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storage = storage
        loadTasks()
    }

    func addTask(title: String) {
        tasks.append(TaskItem(title: title))
        saveTasks(tasks)
    }

    func toggleTask(_ task: TaskItem) {
        tasks = tasks.map { t in
            t.id == task.id ? TaskItem(id: t.id, title: t.title, isCompleted: !t.isCompleted) : t
        }
        saveTasks(tasks)
    }

    private func loadTasks() {
        tasks = storage.load(forKey: storageKey)
    }

    private func saveTasks(_ newTasks: [TaskItem]) {
        storage.save(newTasks, forKey: storageKey)
    }
}