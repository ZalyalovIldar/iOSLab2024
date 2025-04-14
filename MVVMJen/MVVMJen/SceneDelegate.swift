//
//  SceneDelegate.swift
//  MVVMJen
//
//  Created by Артур Мавликаев on 11.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Проверяем, что scene можно привести к UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Создаём окно с привязанной сценой
        let window = UIWindow(windowScene: windowScene)
        
        // Создаём стартовый ViewController (например, список задач)
        // Если у вас используется MVVM, этот контроллер может быть настроен через свой ViewModel
        let taskListVC = TasksViewController()
        
        // Оборачиваем его в UINavigationController (если необходимо)
        let navigationController = UINavigationController(rootViewController: taskListVC)
        
        // Задаём rootViewController
        window.rootViewController = navigationController
        
        // Сохраняем окно (обычно в SceneDelegate создаётся свойство window)
        self.window = window
        
        // Делаем окно ключевым и видимым
        window.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
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
    }


}

