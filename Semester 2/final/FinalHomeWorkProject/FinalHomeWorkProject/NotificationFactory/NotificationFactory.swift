//
//  NotificationFactory.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import Foundation
import UserNotifications

class NotificationFactory {
    static func scheduleNotification(for reminder: Reminder) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = "Время для \(reminder.reminderType.rawValue)"
        content.userInfo = ["screenLink": "reminder://openScreen?screen=detail&id=\(reminder.id)"]
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(reminder.interval * 3600),
            repeats: true
        )
        
        return UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
    }
}
