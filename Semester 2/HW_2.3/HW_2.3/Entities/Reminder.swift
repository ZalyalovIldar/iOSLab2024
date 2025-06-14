//
//  Reminder.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Foundation

struct Reminder: Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let type: ReminderType
}

enum ReminderType: String, CaseIterable {
    case water = "Пить воду"
    case stretch = "Сделать разминку"
    case vitamins = "Витамины"
    case sleep = "Лечь спать"
    case exercise = "Зарядка"
    case meal = "Приём пищи"
    case breathing = "Дыхательные упражнения"
    case custom = "Другое"
}
