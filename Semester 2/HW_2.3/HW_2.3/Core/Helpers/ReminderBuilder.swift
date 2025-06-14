//
//  ReminderBuilder.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Foundation

final class ReminderBuilder {
    private var id = UUID()
    private var title: String = ""
    private var date: Date = Date()
    private var type: ReminderType = .custom

    func setId(_ id: UUID) -> Self {
        self.id = id
        return self
    }

    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }

    func setDate(_ date: Date) -> Self {
        self.date = date
        return self
    }

    func setType(_ type: ReminderType) -> Self {
        self.type = type
        return self
    }
 
    func build() -> Reminder {
        Reminder(id: id, title: title, date: date, type: type)
    }
}
