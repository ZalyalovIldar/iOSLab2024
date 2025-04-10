//
//  SceneDelegate.swift
//  HW2
//
//  Created by Терёхин Иван on 22.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let naviationController = UINavigationController(rootViewController: PostViewController())
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = naviationController
        window?.makeKeyAndVisible()
    }
    
}

