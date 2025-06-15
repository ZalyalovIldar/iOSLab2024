//
//  SceneDelegate.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(
            rootViewController: Bulder.getTaskViewConroller())
        window?.makeKeyAndVisible()
    }
}

