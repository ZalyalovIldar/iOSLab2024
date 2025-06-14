//
//  ReminderService.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Combine
import Foundation

protocol ReminderServiceProtocol {
    func add(_ reminder: Reminder)
    var remindersPublisher: AnyPublisher<[Reminder], Never> { get }
    func reminder(with id: UUID) -> Reminder?
}

final class ReminderService: ReminderServiceProtocol {
    @Published private(set) var reminders: [Reminder] = []

    var remindersPublisher: AnyPublisher<[Reminder], Never> {
        $reminders.eraseToAnyPublisher()
    }

    func add(_ reminder: Reminder) {
        reminders.append(reminder)
    }

    func reminder(with id: UUID) -> Reminder? {
        return reminders.first { $0.id == id }
    }
}
