//
//  DeeplinkHandler.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Foundation

protocol DeeplinkHandlerProtocol {
    func handleDeeplink(_ url: URL)
}

final class DeeplinkHandler: DeeplinkHandlerProtocol {
    var onOpenReminderDetail: ((Reminder) -> Void)?
    private let reminderService: ReminderServiceProtocol

    init(reminderService: ReminderServiceProtocol) {
        self.reminderService = reminderService
    }
    
    func handleDeeplink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        switch components.host {
        case "openScreen":
            handleOpenScreen(with: components.queryItems ?? [])
        default:
            break
        }
    }

    private func handleOpenScreen(with queryItems: [URLQueryItem]) {
        let screenQuery = queryItems.first { $0.name == "screen" }
        switch screenQuery?.value {
        case "detail":
            handleDetailScreen(with: queryItems)
        default:
            break
        }
    }

    private func handleDetailScreen(with queryItems: [URLQueryItem]) {
        guard
            let idString = queryItems.first(where: { $0.name == "id" })?.value,
            let uuid = UUID(uuidString: idString),
            let reminder = reminderService.reminder(with: uuid)
        else { return }
        
        onOpenReminderDetail?(reminder)
    }
}
