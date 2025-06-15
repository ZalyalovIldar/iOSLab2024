//
//  CustomActionView.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit

class CustomGenreView: UIView {
    
    private lazy var ticketImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .ticket))
        image.tintColor = Color.customGrey
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Constant.Font.small)
        label.textColor = Color.customGrey
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGenre(genre: String) {
        genreLabel.text = genre
    }
    
    private func setupLayout() {
        addSubview(ticketImage)
        addSubview(genreLabel)
        NSLayoutConstraint.activate([
            ticketImage.heightAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            ticketImage.widthAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            ticketImage.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraint.marginSmall),
            ticketImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraint.marginMedium),
            ticketImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Constraint.marginSmall),
            
            genreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: ticketImage.trailingAnchor, constant: Constant.Constraint.marginTiny),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraint.marginMedium)
        ])
    }

}
