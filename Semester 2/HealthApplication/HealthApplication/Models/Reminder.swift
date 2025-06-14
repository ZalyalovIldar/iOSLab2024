import Foundation

struct Reminder: Identifiable, Equatable, Codable{
    let id: UUID
    let title: String
    let interval: Int
    let type: ReminderType
    
    static func == (lhs: Reminder, rhs: Reminder) -> Bool{
        return lhs.id == rhs.id
    }
    
    static func stub() -> Reminder{
        Reminder(id: UUID(), title: "Пить воду", interval: 30, type: .water)
    }
}
