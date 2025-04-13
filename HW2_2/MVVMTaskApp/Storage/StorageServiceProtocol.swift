import Foundation

protocol StorageServiceProtocol {
    func save<T: Storable>(_ objects: [T], forKey key: String)
    func load<T: Storable>(forKey key: String) -> [T]
    func deleteAll(forKey key: String)
}