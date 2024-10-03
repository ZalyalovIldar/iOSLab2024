//
//  UserThirdSectionTableViewCell.swift
//  HW_1
//
//  Created by Артур Мавликаев on 03.10.2024.
//

import UIKit

class UserThirdSectionTableViewCell: UITableViewCell {
    
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical 
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(imageStackView)
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with images: [UIImage?]) {
        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for image in images {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            imageStackView.addArrangedSubview(imageView)
        }
    }
}
