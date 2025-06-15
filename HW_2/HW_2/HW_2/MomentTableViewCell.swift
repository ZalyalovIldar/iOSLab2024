//
//  MomentTableViewCell.swift
//  HW_2
//
//  Created by Павел Калинин on 20.10.2024.
//


import UIKit

class MomentTableViewCell: UITableViewCell {
    private var images: [UIImage] = []
    
    private lazy var contentStack: UIStackView = {
        var contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 5
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(imagesStack)
        contentStack.addArrangedSubview(descriptionStack)
        return contentStack
    }()
    
    private lazy var imagesStack: UIStackView = {
        var imagesStack = UIStackView()
        imagesStack.axis = .horizontal
        imagesStack.spacing = 5
        imagesStack.distribution = .fillEqually
        imagesStack.translatesAutoresizingMaskIntoConstraints = false
        return imagesStack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var descriptionStack: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateLabel)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imagesStack)
        contentView.addSubview(contentStack)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupStackView() {
        imagesStack.arrangedSubviews.forEach{$0.removeFromSuperview()}
        for i in 0..<min(images.count, 2) {
            let imageView = createImageView(with: images[i])
            imagesStack.addArrangedSubview(imageView)
        }
        imagesStack.heightAnchor.constraint(equalToConstant: images.isEmpty ? 0 : 200).isActive = true
    }
    
    private func createImageView(with image: UIImage) -> UIImageView {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = image
            return imageView
        }()
        return imageView
    }
    
    
    func configure(with moment: Moment) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        descriptionLabel.text = moment.description
        dateLabel.text = formatter.string(from: moment.date)
        images = moment.images
        
        setupStackView()
    }
}

extension MomentTableViewCell {
    static var reuseIdentifier = "MomentTableViewCell"
}
