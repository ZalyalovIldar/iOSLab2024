//
//  PushNotificationService.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import Foundation
import UserNotifications

protocol PushNotificationServiceProtocol {
    func registerNotification() async throws -> Bool
    func open(url: URL)
    func scheduleNotification(_ request: UNNotificationRequest)
}

class PushNotificationService: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func registerNotification() async throws -> Bool {
        return try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    }
    
    func open(url: URL) {
        ServiceLocator.shared.configureDeepLinkHandler().handleDeeplink(url)
    }
    
    func scheduleNotification(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request)
    }
}

extension PushNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let screenLink = userInfo["screenLink"] as? String, let url = URL(string: screenLink) else { return }
        open(url: url)
        completionHandler()
                
    }
}
