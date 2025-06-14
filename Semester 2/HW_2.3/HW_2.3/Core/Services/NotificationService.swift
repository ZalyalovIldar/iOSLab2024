//
//  NotificationService.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorizationIfNeeded()
    func scheduleNotification(_ request: UNNotificationRequest)
    func cancelNotification(id: String)
    func handleOpen(_ url: URL)
}

final class NotificationService: NSObject, NotificationServiceProtocol {

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus != .authorized else { return }
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error)")
                } else {
                    print("Notification permission granted: \(granted)")
                }
            }
        }
    }
    
    func scheduleNotification(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled: \(request.identifier)")
            }
        }
    }
    
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    func handleOpen(_ url: URL) {
        ServiceLocator.shared.deeplinkHandler.handleDeeplink(url)
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let screenLink = userInfo["screenLink"] as? String,
            let url = URL(string: screenLink) else { return }
        handleOpen(url)
        completionHandler()
    }
}

