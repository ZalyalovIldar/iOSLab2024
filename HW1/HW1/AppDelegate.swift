//
//  AppDelegate.swift
//  HW1
//
//  Created by дилара  on 04.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let profileViewController = ProfileViewController()
        window?.rootViewController = UINavigationController(rootViewController: profileViewController)
        window?.makeKeyAndVisible()
        return true
    }
}

