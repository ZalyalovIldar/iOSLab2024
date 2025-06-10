import Foundation

class UserDefaultsStorage<T: Codable>: StorageService {
    private let key = "tasks"
    
    func save(items: [T]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func load() -> [T] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([T].self, from: data) {
            return decoded
        }
        return []
    }
}
