//
//  MomentTableViewCell.swift
//  MyMoment
//
//  Created by Павел on 20.10.2024.
//

import UIKit

class MomentTableViewCell: UITableViewCell {

    // MARK: - Properties

    private var photos: [UIImage] = []

    // MARK: - UI Elements

    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentStackView)
        view.backgroundColor = .systemGray6
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            imagesStackView,
            descriptionLabel,
            dateLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        return stackView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 5
        label.textAlignment = .natural
        return label
    }()

    // MARK: - Setup

    private func updateImages() {
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<min(photos.count, 2) {
            let imageView = UIImageView(image: photos[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 5
            imagesStackView.addArrangedSubview(imageView)
        }
        imagesStackView.isHidden = photos.isEmpty
        imagesStackView.heightAnchor.constraint(equalToConstant: photos.isEmpty ? 0 : 200).isActive = true
    }

    private let constraintConstant: CGFloat = 5

    private func setupUI() {
        contentView.addSubview(view)
        contentView.backgroundColor = .white
        let bottomPadding: CGFloat = -10

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraintConstant),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: constraintConstant),
            titleLabel.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: constraintConstant),

            imagesStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: constraintConstant),
            imagesStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -constraintConstant),
            imagesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: constraintConstant),

            descriptionLabel.topAnchor.constraint(equalTo: imagesStackView.bottomAnchor, constant: constraintConstant),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: constraintConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -constraintConstant),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -constraintConstant),

            dateLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -constraintConstant * 2),
        ])
    }

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configureCell(with post: Post) {
        dateLabel.text = post.date.formatted(date: .numeric, time: .shortened)
        descriptionLabel.text = post.text
        photos = post.photos
        titleLabel.text = post.title

        updateImages()
    }
}

// MARK: - Identifier

extension MomentTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
