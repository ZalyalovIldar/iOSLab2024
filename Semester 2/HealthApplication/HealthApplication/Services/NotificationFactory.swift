import UserNotifications

class NotificationFactory{
    static func schedule(notificationFor reminder: Reminder){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = "Пора \(reminder.type.description)"
        content.sound = .default
        content.userInfo = ["id": reminder.id.uuidString]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(reminder.interval * 60), repeats: true)
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
}
