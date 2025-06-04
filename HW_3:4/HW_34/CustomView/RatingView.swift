//
//  RatingView.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 14.01.25.
//

import UIKit

class Rating: UIView {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = SpacingConstants.tiny
        view.backgroundColor = Colors.backgroud.withAlphaComponent(0.8)
        return view
    }()
    
    private lazy var starView: UIImageView = {
        let star = UIImageView(image: UIImage(systemName: "star"))
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }()
    
    private lazy var ratingTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-SemiBold", size: FontConstants.plain)
        
        return label
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            starView,
            ratingTitle
        ])
        stack.axis = .horizontal
        stack.spacing = SpacingConstants.tiny
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRating(rating: Double) {
        ratingTitle.text = "\(rating)"
        
        switch rating {
        case 0.0 ... 3.9:
            starView.tintColor = .systemRed
            ratingTitle.textColor = .systemRed
        case 4.0 ... 7.9:
            starView.tintColor = .systemOrange
            ratingTitle.textColor = .systemOrange
        default:
            starView.tintColor = .systemGreen
            ratingTitle.textColor = .systemGreen
        }
    }
    
    private func setup() {
        addSubview(backgroundView)
        backgroundView.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: SpacingConstants.tiny),
            dataStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -SpacingConstants.tiny),
            dataStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: SpacingConstants.tiny),
            dataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -SpacingConstants.tiny)
        ])
    }
}
