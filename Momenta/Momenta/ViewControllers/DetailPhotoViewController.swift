//
//  DetailPhotoViewController.swift
//  Momenta
//
//  Created by Тагир Файрушин on 05.11.2024.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }

        let button = UIButton(configuration: .plain(), primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(photo: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image.image = photo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    private func layout() {
        view.addSubview(button)
        view.addSubview(image)

        NSLayoutConstraint.activate([
            // Ограничения для кнопки, чтобы она занимала весь экран
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // Ограничения для изображения внутри кнопки
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        ])
    }
    
    
}
