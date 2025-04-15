class TaskViewModel<Storage: StorageServiceProtocol> where Storage.T == TaskItem {
    
    private var storageService: Storage
    
    init(storageService: Storage) {
        self.storageService = storageService
    }
    
    func saveTask(_ task: TaskItem, forKey key: String) {
        storageService.save(item: task, forKey: key)
    }
    
    func getTask(forKey key: String) -> TaskItem? {
        return storageService.get(forKey: key)
    }
    
    func updateTask(_ task: TaskItem, forKey key: String) {
        storageService.update(item: task, forKey: key)
    }
    
    func deleteTask(forKey key: String) {
        storageService.delete(forKey: key)
    }
    
    func getAllTasks() -> [TaskItem] {
        return storageService.getAllItems()
    }
}

