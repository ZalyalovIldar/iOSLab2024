//
//  SceneDelegate.swift
//  Films
//
//  Created by Артур Мавликаев on 06.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Создаем контроллеры для вкладок
        let mainViewController = MainViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainNavigationController.navigationBar.barTintColor = UIColor(
            red: 36/255,
            green: 42/255,
            blue: 50/255,
            alpha: 1
        )
        mainNavigationController.navigationBar.tintColor = UIColor.white
        mainNavigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        mainNavigationController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
        
        let favoritesViewController = FavoriteUIViewViewController()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.navigationBar.barTintColor = UIColor(
            red: 36/255,
            green: 42/255,
            blue: 50/255,
            alpha: 1
        )
        favoritesNavigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        favoritesViewController.title = "Избранное"
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "star"), tag: 1)
        
        // Создаем Tab Bar Controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNavigationController, favoritesNavigationController]
        tabBarController.tabBar.barTintColor = UIColor(
            red: 36/255,
            green: 42/255,
            blue: 50/255,
            alpha: 1
        )
        
        // Устанавливаем Tab Bar Controller как корневой
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
