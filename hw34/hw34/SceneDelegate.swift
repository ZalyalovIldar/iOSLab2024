import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = createTabBarController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let watchListViewController = UINavigationController(rootViewController: WatchListViewController())
        watchListViewController.tabBarItem = UITabBarItem(title: "Watch list", image: UIImage(systemName: "list.bullet"), tag: 2)

        tabBarController.viewControllers = [
            homeViewController,
            searchViewController,
            watchListViewController
        ]

        return tabBarController
    }
}

