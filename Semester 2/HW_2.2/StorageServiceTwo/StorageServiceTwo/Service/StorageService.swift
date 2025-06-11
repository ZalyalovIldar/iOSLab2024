import Foundation

class StorageService<T: Codable>: StorageServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let storageKey: String
    private var items: [String: T] = [:]
    
    init(storageKey: String = "storage_\(String(describing: T.self))") {
        self.storageKey = storageKey
        loadFromUserDefaults()
    }
    
    func save(item: T, forKey key: String) {
        items[key] = item
        saveToUserDefaults()
    }
    
    func get(forKey key: String) -> T? {
        return items[key]
    }
    
    func update(item: T, forKey key: String) {
        items[key] = item
        saveToUserDefaults()
    }
    
    func delete(forKey key: String) {
        items.removeValue(forKey: key)
        saveToUserDefaults()
    }
    
    func getAllItems() -> [T] {
        return Array(items.values)
    }

    private func saveToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Ошибка кодирования данных для UserDefaults: \(error)")
        }
    }
    
    private func loadFromUserDefaults() {
        guard let data = userDefaults.data(forKey: storageKey) else { return }
        do {
            items = try JSONDecoder().decode([String: T].self, from: data)
        } catch {
            print("Ошибка декодирования данных из UserDefaults: \(error)")
        }
    }
}

