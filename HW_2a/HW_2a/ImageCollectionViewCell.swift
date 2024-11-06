//
//  ImageCollectionViewCell.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 29.10.2024.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: ImageCollectionViewCell)
}

final class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"

    weak var delegate: ImageCollectionViewCellDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showDeleteButton))
        contentView.addGestureRecognizer(longPressGesture)
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage) {
        imageView.image = image
        deleteButton.isHidden = true 
    }

    @objc private func showDeleteButton() {
        deleteButton.isHidden = false
    }

    @objc private func deleteImage() {
        delegate?.didTapDeleteButton(in: self)
    }
}
