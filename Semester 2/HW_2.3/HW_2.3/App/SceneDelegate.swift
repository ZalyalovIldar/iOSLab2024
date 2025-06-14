//
//  SceneDelegate.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let router = AppRouter()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setupServiceLocator()
        //Для теста перехода по диплинку
        setupForDeeplinkTest()

        let vc = UINavigationController(rootViewController: MainAssembly.build())
        router.navigationController = vc
        window?.rootViewController = vc
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
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        let url = urlContext.url
        ServiceLocator.shared.deeplinkHandler.handleDeeplink(url)
    }
}

extension SceneDelegate {
    private func setupServiceLocator() {
        let locator = ServiceLocator.shared
        let reminderService = ReminderService()
        locator.register(NotificationService())
        locator.register(reminderService)
        
        let deeplinkHandler = DeeplinkHandler(reminderService: reminderService)
        deeplinkHandler.onOpenReminderDetail = {[weak router] reminder in
            router?.openReminderDetailScreen(for: reminder)
        }
        locator.register(deeplinkHandler)
    }

    private func setupForDeeplinkTest() {
        if CommandLine.arguments.contains("--uitesting-deeplink") {
            if let linkString = ProcessInfo.processInfo.environment["TEST_SCREEN_LINK"],
               let url = URL(string: linkString) {
                
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let queryItem = components.queryItems?.first(where: { $0.name == "id" }),
                   let idString = queryItem.value,
                   let uuid = UUID(uuidString: idString) {
                    
                    let reminder = ReminderBuilder()
                        .setId(uuid)
                        .setTitle("UI-тест напоминание")
                        .setDate(Date().addingTimeInterval(600))
                        .setType(.custom)
                        .build()
                    ServiceLocator.shared.remindersService.add(reminder)
                }
                ServiceLocator.shared.deeplinkHandler.handleDeeplink(url)
            }
        }
    }
}
