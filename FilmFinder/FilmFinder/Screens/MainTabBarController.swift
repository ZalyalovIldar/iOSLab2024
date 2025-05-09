//
//  MainTabBarController.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        let homeController = createController(
            rootViewController: HomeViewController(),
            title: "Home",
            image: UIImage(systemName: "house")!,
            selectedImage: UIImage(systemName: "house.fill")!)
        
        let favoriteController = createController(rootViewController: FavoriteViewController(), title: "watch list", image: UIImage(systemName: "bookmark")!, selectedImage: UIImage(systemName: "bookmark.fill")!)
        
        viewControllers = [homeController, favoriteController]
        tabBar.barTintColor = Color.backgroundColor
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .white
    }
 
    private func createController(
        rootViewController: UIViewController,
        title: String,
        image: UIImage,
        selectedImage: UIImage
    ) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navigationController.navigationBar.barTintColor = Color.backgroundColor
        
        return navigationController
    }

}
