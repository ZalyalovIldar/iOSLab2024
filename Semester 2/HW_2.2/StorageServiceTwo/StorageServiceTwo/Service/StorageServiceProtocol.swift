import Foundation

protocol StorageServiceProtocol {
    associatedtype T: Codable
    func save(item: T, forKey key: String)
    func get(forKey key: String) -> T?
    func update(item: T, forKey key: String)
    func delete(forKey key: String)
    func getAllItems() -> [T]
}
