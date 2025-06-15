//
//  MainTabBarController.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
  // Цвет для выбранных элементов
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "back")

        // Настраиваем цвет для невыбранных и выбранных элементов
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "tabbar")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "tabbar")!]

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        let homeVC = MoviesViewController()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))

        let searchVC = WatchlistViewController()
        let searchNavController = UINavigationController(rootViewController: searchVC)
        searchNavController.tabBarItem = UITabBarItem(title: "Watch list", image: UIImage(named: "watch"), selectedImage: UIImage(named: "watch"))

        viewControllers = [homeNavController, searchNavController]
    }
}



