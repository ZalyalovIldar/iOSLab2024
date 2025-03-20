import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()

    }
    
    private func setupController() {
        let homeController = HomeViewController()
        let favoritesController = FavoritesViewController()
        let homeNavitationController = UINavigationController(rootViewController: homeController)
        let favoriteNavitationController = UINavigationController(rootViewController: favoritesController)
        
        self.viewControllers = [homeNavitationController, favoriteNavitationController]
        
        homeController.tabBarItem = UITabBarItem(title: Constant.TabBarController.titleHome,
                                                 image: .init(systemName: Constant.TabBarController.iconHome), tag: 0)
        
        favoritesController.tabBarItem = UITabBarItem(title: Constant.TabBarController.titleFavorites,
                                                      image: .init(
                                                        systemName: Constant.TabBarController.iconFavorites), tag: 1)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constant.TabBarController.backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           
        homeNavitationController.navigationBar.standardAppearance = appearance
        homeNavitationController.navigationBar.scrollEdgeAppearance = appearance
           
        favoriteNavitationController.navigationBar.standardAppearance = appearance
        favoriteNavitationController.navigationBar.scrollEdgeAppearance = appearance
        
        tabBar.backgroundColor = Constant.TabBarController.backgroundColor
        tabBar.unselectedItemTintColor = Constant.TabBarController.unselectedItemTintColor
        tabBar.tintColor = Constant.TabBarController.selectedItemTintColor
        tabBar.barTintColor = Constant.TabBarController.backgroundColor
   
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = Constant.TabBarController.separatorLineColor
        view.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
              separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              separatorLine.bottomAnchor.constraint(equalTo: tabBar.topAnchor,
                                                    constant: Constant.TabBarController.separationViewTopAnchor),
              separatorLine.heightAnchor.constraint(equalToConstant: Constant.TabBarController.separationViewHeightAnchor)
          ])
    }
}
