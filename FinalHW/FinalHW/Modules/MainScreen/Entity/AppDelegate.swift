import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainModuleFactory.build()
        window?.makeKeyAndVisible()
        
        // Запрос разрешения на уведомления
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Ошибка запроса уведомлений: $error)")
            }
            print("Разрешение на уведомления: $granted)")
        }
        
        return true
    }
}
