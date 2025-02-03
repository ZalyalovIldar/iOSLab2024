import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = Colors.mainGray // Background color of the tab bar
        
        // Set selected and unselected item colors
        tabBarController.tabBar.tintColor = UIColor.init(hex: "E98A9E") // Color for selected item
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray // Color for unselected items
        
        // Main screen setup
        let mainScreen = MainScreenController()
        mainScreen.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "play.house"),
            tag: 0
        )
        let mainScreenNavigationController = UINavigationController(rootViewController: mainScreen)
        mainScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
        
        // Favorite films screen setup
        let favouriteFilmsScreen = BookmarkedMoviesController()
        favouriteFilmsScreen.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "bookmark"),
            tag: 1
        )
        let favouriteFilmsScreenNavigationController = UINavigationController(rootViewController: favouriteFilmsScreen)
        favouriteFilmsScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
        
        // Add view controllers to the tab bar controller
        tabBarController.viewControllers = [mainScreenNavigationController, favouriteFilmsScreenNavigationController]
        
        // Set the tab bar controller as the root
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        // (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

