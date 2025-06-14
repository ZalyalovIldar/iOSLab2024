import Foundation

struct ReminderBuilder {
    static func build(title: String, interval: Int, type: ReminderType) -> Reminder{
        Reminder(id: UUID(), title: title, interval: interval, type: type)
    }
}
