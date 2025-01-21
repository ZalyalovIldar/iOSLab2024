import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vcH = UINavigationController(rootViewController: HomepageViewController())
        let vcS = UINavigationController(rootViewController: SearchMoviesViewController())
        let vcF = UINavigationController(rootViewController: FavouriteMoviesViewController())
        
        tabBar.tintColor = .label
        
        vcH.tabBarItem.image = UIImage(systemName: "house.fill")
        vcS.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vcF.tabBarItem.image = UIImage(systemName: "star.circle.fill")
        
        vcH.title = "Главная"
        vcS.title = "Поиск"
        vcF.title = "Избранное"
        
        setViewControllers([vcH, vcS, vcF], animated: true)
    }

}

