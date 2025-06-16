//
//  ViewController.swift
//  CarthageTask3
//
//  Created by Anna on 22.03.2025.
//

import UIKit
import SDWebImage


class ViewController: UIViewController {


    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем по горизонтали
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor), // Центрируем по вертикали
            imageView.widthAnchor.constraint(equalToConstant: 200), // Ширина 200 точек
            imageView.heightAnchor.constraint(equalToConstant: 200) // Высота 200 точек
        ])
        
        let imageURL = URL(string: "https://cdn2.thecatapi.com/images/22k.jpg")
        imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) { (image, error, cacheType, url) in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
            } else {
                print("Изображение успешно загружено")
            }
        }
    }
}
