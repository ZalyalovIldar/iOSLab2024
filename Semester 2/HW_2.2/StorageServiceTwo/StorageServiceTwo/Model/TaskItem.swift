import Foundation

struct TaskItem: Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
}
