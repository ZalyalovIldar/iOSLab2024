//
//  PostCell.swift
//  hw_2
//
//  Created by Кирилл Титов on 21.11.2024.
//

import UIKit

final class PostCell: UICollectionViewCell {
    static let identifier = "PostCell"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imagesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(imagesContainerView)
        contentView.addSubview(textLabel)
        contentView.addSubview(dateLabel)

        imagesContainerView.addSubview(imageView1)
        imagesContainerView.addSubview(imageView2)

        NSLayoutConstraint.activate([
            imagesContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imagesContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagesContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            imagesContainerView.heightAnchor.constraint(equalToConstant: 100),

            imageView1.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
            imageView1.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
            imageView1.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor),
            imageView1.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),

            imageView2.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 8),
            imageView2.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
            imageView2.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor),
            imageView2.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),

            textLabel.topAnchor.constraint(equalTo: imagesContainerView.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with post: Post) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: post.date)
        
        textLabel.text = post.text

        if post.images.isEmpty {
            imagesContainerView.isHidden = true
        } else {
            imagesContainerView.isHidden = false
            imageView1.image = post.images[0]
            imageView1.isHidden = false

            if post.images.count > 1 {
                imageView2.image = post.images[1]
                imageView2.isHidden = false
            } else {
                imageView2.isHidden = true
            }
        }
    }
}

