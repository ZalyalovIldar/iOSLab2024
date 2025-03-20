//
//  CustomRatingView.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit

class CustomRatingView: UIView {
    
    private lazy var starImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star"))
        image.tintColor = .systemOrange
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Constant.Font.small)
        label.textColor = .systemOrange
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundColor
        setupLayout()
    }
    
    func setRating(rating: String) {
        ratingLabel.text = rating
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(starImage)
        addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            starImage.heightAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            starImage.widthAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            starImage.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraint.marginSmall),
            starImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraint.marginMedium),
            starImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Constraint.marginSmall),
            
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: Constant.Constraint.marginTiny),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
