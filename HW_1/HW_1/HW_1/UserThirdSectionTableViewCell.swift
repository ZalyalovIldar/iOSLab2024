//
//  UserThirdSectionTableViewCell.swift
//  HW_1
//
//  Created by Артур Мавликаев on 03.10.2024.
//

import UIKit

class UserThirdSectionTableViewCell: UITableViewCell {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageStackView)

        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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

        
        layoutIfNeeded()
    }
}

