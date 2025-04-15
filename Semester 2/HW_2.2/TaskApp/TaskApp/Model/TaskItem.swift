import Foundation

struct TaskItem: Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}
