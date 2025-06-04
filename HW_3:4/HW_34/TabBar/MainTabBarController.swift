//
//  MainTabBarController.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 12.01.25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        tabBar.barTintColor = Colors.backgroud
        
        let mainScreen = MainScreenController()
        mainScreen.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "play.house"),
            tag: 0
        )
        let mainScreenNav = UINavigationController(rootViewController: mainScreen)
        mainScreenNav.navigationBar.barTintColor = Colors.backgroud
        
        let favouritesScreen = FavouriteController()
        favouritesScreen.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "bookmark"),
            tag: 1
        )
        let favouritesNav = UINavigationController(rootViewController: favouritesScreen)
        favouritesNav.navigationBar.barTintColor = Colors.backgroud
        
        viewControllers = [mainScreenNav, favouritesNav]
    }
}
