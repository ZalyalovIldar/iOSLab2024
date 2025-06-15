//
//  ReminderService.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import Foundation
import Combine

protocol ReminderServiceProtocol {
    func addReminder(_ reminder: Reminder)
    var remindersPublisher: AnyPublisher<[Reminder], Never> { get }
    func reminder(with id: String) -> Reminder?
   
}

final class ReminderService: ReminderServiceProtocol {
    @Published private(set) var reminders: [Reminder] = []
    
    var remindersPublisher: AnyPublisher<[Reminder], Never> {
        $reminders.eraseToAnyPublisher()
    }
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        let request = NotificationFactory.scheduleNotification(for: reminder)
        ServiceLocator.shared.configurePushNotificationService().scheduleNotification(request)
    }
    
    func reminder(with id: String) -> Reminder? {
        return reminders.first { $0.id == id }
    }
}

