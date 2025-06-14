import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
        var navigationController: UINavigationController? // Store the navigation controller

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            let mainVC = ReminderListView()
            let navigationController = UINavigationController(rootViewController: mainVC) // Create nav controller
            self.navigationController = navigationController // Store it

            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                self.window = window
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}

extension UIApplication {
    static func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return nil}
        let keyWindow = windowScene.windows.first {$0.isKeyWindow}
        return keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController{
            return presented.topMostViewController()
        }
        if let nav = self as? UINavigationController{
            return nav.visibleViewController?.topMostViewController() ?? nav
        }
        if let tab = self as? UITabBarController{
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}
