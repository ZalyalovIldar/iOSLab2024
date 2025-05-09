//
//  CutomTabBarController.swift
//  Movies
//
//  Created by Павел Калинин on 20.12.2024.
//

import UIKit

class CustomTabBarController: UITabBarController {
    private var customTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.mainColor
        view.layer.borderColor = AppColors.tabBarItemColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private var tabBarItems: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomTabBar()
        setupViewControllers()
        selectTab(at: 0) // Выбираем первую вкладку по умолчанию
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = 90
        let tabBarFrame = tabBar.frame
        customTabBarView.frame = CGRect(x: tabBarFrame.minX - 2,
                                        y: tabBarFrame.minY - (height - tabBarFrame.height),
                                        width: tabBarFrame.width + 4,
                                        height: height + 4)
        tabBar.isHidden = true
    }

    private func setupCustomTabBar() {
        view.addSubview(customTabBarView)
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        let homeButton = createTabBarItem(title: "Главная", image: UIImage.home, tag: 0)
        let profileButton = createTabBarItem(title: "Избранное", image: UIImage.saved, tag: 1)
        
        tabBarItems = [homeButton, profileButton] // Сохраняем кнопки для изменения их состояния
        
        tabBarItems.forEach { button in
            stackView.addArrangedSubview(button)
        }
        
        customTabBarView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: customTabBarView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: customTabBarView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor, constant: -60)
        ])
    }

    private func createTabBarItem(title: String, image: UIImage, tag: Int) -> UIButton {
        let imageView: UIImageView = {
            let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray
            return imageView
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            return label
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.isUserInteractionEnabled = false
            return stackView
        }()
        
        let button: UIButton = {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(stackView)
            button.tag = tag
            button.addTarget(self, action: #selector(tabBarButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        return button
    }

    @objc private func tabBarButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectTab(at: index)
    }

    private func selectTab(at index: Int) {
        // Переключаем текущий контроллер
        selectedIndex = index
        
        // Обновляем состояние кнопок
        for (itemIndex, button) in tabBarItems.enumerated() {
            let isSelected = itemIndex == index
            let color: UIColor = isSelected ? AppColors.tabBarItemColor : .gray
            
            // Изменяем цвет текста и изображения
            if let stackView = button.subviews.first(where: { $0 is UIStackView }) as? UIStackView,
               let imageView = stackView.arrangedSubviews.first as? UIImageView,
               let label = stackView.arrangedSubviews.last as? UILabel {
                imageView.tintColor = color
                label.textColor = color
            }
        }
    }

    private func setupViewControllers() {
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        let watchListViewController = UINavigationController(rootViewController: WatchListViewController())
        viewControllers = [mainViewController, watchListViewController]
    }
}
