//
//  RatingView.swift
//  JSONParcingTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit

final class RatingView: UIView {
    
    private lazy var firstStar: UIImageView = {
        getStarView()
    }()
    
    private lazy var secondStar: UIImageView = {
        getStarView()
    }()
    
    private lazy var thirdStar: UIImageView = {
        getStarView()
    }()
    
    private lazy var fourthStar: UIImageView = {
        getStarView()
    }()
    
    private lazy var fifthStar: UIImageView = {
        getStarView()
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstStar,
            secondStar,
            thirdStar,
            fourthStar,
            fifthStar
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()
    
    func setupWithJokeRating(rating: Int) {
        let stars = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]
        for (index, star) in stars.enumerated() {
            star.tintColor = index < rating ? .systemYellow : .systemGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RatingView {
    
    func getStarView() -> UIImageView {
        let image = UIImageView(image: UIImage(systemName: "star.fill"))
        image.tintColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    func setup() {
        setupSubviews()
        setupContraints()
    }
    
    func setupSubviews() {
        addSubview(dataStackView)
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            dataStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            dataStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            dataStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
