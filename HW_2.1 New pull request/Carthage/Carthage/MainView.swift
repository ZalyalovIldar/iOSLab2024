//
//  MainView.swift
//  Carthage
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import UIKit
import SDWebImage

class MainView: UIView {
    private lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://usagif.com/wp-content/uploads/2022/fzk5d/5-jumping-watermelon-dance-acegif.gif"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://c.tenor.com/_L8Aapr1MiIAAAAC/tenor.gif"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView1, imageView2])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(stackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.medium),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.medium),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.medium),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.medium)
        ])
    }
}
