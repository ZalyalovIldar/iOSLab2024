//
//  Reminder.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import Foundation

enum ReminderType: String, Identifiable, Hashable, CaseIterable {
    case drinkWater = "Пить воду"
    case stretch = "Сделать разминку"
    case vitamins = "Витамины"
    case sleep = "Лечь спать"
    case workout = "Зарядка"
    case meal = "Приём пищи"
    case breathing = "Дыхательные упражнения"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .drinkWater:
            return "drop.fill"
        case .stretch:
            return "figure.walk"
        case .vitamins:
            return "pills.fill"
        case .sleep:
            return "moon.fill"
        case .workout:
            return "figure.run"
        case .meal:
            return "fork.knife"
        case .breathing:
            return "wind"
        }
    }
    
}

struct Reminder: Hashable {
    let id: String
    let title: String
    let reminderType: ReminderType
    let interval: TimeInterval
}
