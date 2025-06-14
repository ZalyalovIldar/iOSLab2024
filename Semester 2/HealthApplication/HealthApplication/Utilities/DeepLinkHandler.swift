import UserNotifications
import SwiftUI
import UIKit

class DeepLinkHandler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = DeepLinkHandler()

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let id = userInfo["id"] as? String, let uuid = UUID(uuidString: id),
           let reminder = ReminderService.shared.reminders.first(where: { $0.id == uuid }) {

            let detailView = ReminderDetailView(reminder: reminder)
            let hostingVC = UIHostingController(rootView: detailView)

            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate,
               let navController = delegate.navigationController {
                navController.present(hostingVC, animated: true)
            } else {
                print("Could not find navigation controller")
            }
        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

