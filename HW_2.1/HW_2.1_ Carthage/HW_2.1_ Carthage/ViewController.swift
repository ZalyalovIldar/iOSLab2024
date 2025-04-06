//
//  ViewController.swift
//  HW_2.1_ Carthage
//
//  Created by Павел Калинин on 17.03.2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadImage()
    }
    
    func setupLayout() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func loadImage() {
        let imageUrl = URL(string: "https://media.kudago.com/images/movie/poster/da/e5/dae5cac5b1dd27f4cf458699b2bd9b2b.jpg")
        imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
    }
}

