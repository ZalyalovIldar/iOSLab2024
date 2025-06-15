//
//  ServiceLocator.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    private var reminderService: ReminderService!
    private var pushNotificationService: PushNotificationService!
    private var deepLinkHandler: DeeplinkHandler!
    
    private init() {
        reminderService = ReminderService()
        pushNotificationService = PushNotificationService()
        deepLinkHandler = DeeplinkHandler(reminderService: reminderService)
    }
    
    private var services: [String: Any] = [:]
    
    func configureReminderService() -> ReminderService {
        return reminderService
    }
    
    func configurePushNotificationService() -> PushNotificationService {
        return pushNotificationService
    }
    
    func configureDeepLinkHandler() -> DeeplinkHandler {
        return deepLinkHandler
    }
}
