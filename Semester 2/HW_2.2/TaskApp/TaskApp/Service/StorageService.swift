import Foundation

protocol StorageService {
    associatedtype T: Codable
    func save(items: [T])
    func load() -> [T]
}
