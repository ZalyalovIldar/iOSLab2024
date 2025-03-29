//
//  PhotoCollectionViewCell.swift
//  Momenta
//
//  Created by Тагир Файрушин on 16.10.2024.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var removeButton: UIButton = {
        var configure = UIButton.Configuration.plain()
        configure.image = UIImage(systemName: "multiply.circle.fill")
        configure.baseForegroundColor = .white
        let action = UIAction { [weak self] _ in
            self?.removePhotoClosure?()
        }
        let button = UIButton(configuration: configure, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Delegate Closure
    
    var removePhotoClosure: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Layout
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            removeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            removeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5)
        ])
    }
    
    // MARK: Configure Cell

    func configureCell(with image: UIImage, isEdit: Bool) {
        imageView.image = image
        removeButton.isHidden = !isEdit
    }
}

// MARK: Reuse Identifier

extension PhotoCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

