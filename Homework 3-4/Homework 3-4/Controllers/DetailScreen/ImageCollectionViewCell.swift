//
//  ImageCollectionViewCell.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 01.02.2025.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage) {
        imageView.image = image
    }
    func animateAppearance(delay: TimeInterval = 0) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: [.curveEaseOut],
                       animations: {
                           self.alpha = 1
                           self.transform = .identity
                       },
                       completion: nil)
    }
}
