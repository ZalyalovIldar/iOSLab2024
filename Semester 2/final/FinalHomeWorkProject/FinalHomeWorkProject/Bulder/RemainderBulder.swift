//
//  RemainderBulder.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//
import Foundation

class ReminderBuilder {
    private var id: String = UUID().uuidString
    private var title: String = ""
    private var reminderType: ReminderType = .drinkWater
    private var interval: TimeInterval = 3600
    
    func setId(_ id: String) -> ReminderBuilder {
        self.id = id
        return self
    }
    
    func setTitle(_ title: String) -> ReminderBuilder {
        self.title = title
        return self
    }
    
    func setReminderType(_ reminderType: ReminderType) -> ReminderBuilder {
        self.reminderType = reminderType
        return self
    }
    
    func setInterval(_ interval: TimeInterval) -> ReminderBuilder {
        self.interval = interval
        return self
    }
    
    
    func build() -> Reminder {
        return Reminder(
            id: id,
            title: title,
            reminderType: reminderType,
            interval: interval
        )
    }
}
