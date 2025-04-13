import Foundation

class UserDefaultsStorageService: StorageServiceProtocol {
    private let defaults = UserDefaults.standard

    func save<T: Storable>(_ objects: [T], forKey key: String) {
        if let data = try? JSONEncoder().encode(objects) {
            defaults.set(data, forKey: key)
        }
    }

    func load<T: Storable>(forKey key: String) -> [T] {
        guard let data = defaults.data(forKey: key),
              let objects = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return objects
    }

    func deleteAll(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}