//
//  AddReminderViewModel.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import Foundation

class AddReminderViewModel: ObservableObject {
    @Published var reminderTypes: [ReminderType] = ReminderType.allCases
    @Published var selectedType: ReminderType?
    @Published var title: String = ""
    @Published var intervalInHours: Int = 1 {
        didSet {
            interval = TimeInterval(intervalInHours * 3600)
        }
    }
    private var interval: TimeInterval = 3600
    
    private let reminderService = ServiceLocator.shared.configureReminderService()
    
    func saveReminder() {
        guard let selectedType = selectedType else { return }
        
        let finalTitle = title.isEmpty ? selectedType.rawValue : title
        
        let reminder = ReminderBuilder()
            .setId(UUID().uuidString)
            .setTitle(finalTitle)
            .setReminderType(selectedType)
            .setInterval(interval)
            .build()
        reminderService.addReminder(reminder)
    }
}
