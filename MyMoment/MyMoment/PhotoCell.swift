//
//  PhotoCollectionViewCell.swift
//  MyMoment
//
//  Created by Павел on 16.10.2024.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    // MARK: - UI Elements

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        return image
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .lightGray
        return button
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("x", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .black
        button.alpha = 0.7
        button.layer.cornerRadius = 5
        return button
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private let constraintConstant: CGFloat = 5

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraintConstant),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraintConstant),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupAddPhotoButton() {
        imageView.image = nil
        contentView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            addButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }

    func setupDeleteButton() {
        contentView.addSubview(deleteButton)
    }

    // MARK: - Configuration

    func configureCell(with image: UIImage) {
        imageView.image = image
        addButton.removeFromSuperview()
        deleteButton.removeFromSuperview()
        addButton.removeTarget(nil, action: nil, for: .allEvents)
        setupDeleteButton()
    }
}

// MARK: - Identifier

extension PhotoCell {
    static var identifier: String {
        return String(describing: self)
    }
}
