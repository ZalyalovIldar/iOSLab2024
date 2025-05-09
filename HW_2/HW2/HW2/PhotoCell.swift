//
//  PhotoCell.swift
//  HW2
//
//  Created by Терёхин Иван on 22.10.2024.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    private let heightAndWidthConstant: CGFloat = 10
    private let imageViewCornerRadius: CGFloat = 10
    private let addButtonSize: CGFloat = 40
    private let addButtonBorderWidth: CGFloat = 2
    private let addButtonCornerRadius: CGFloat = 5
    private let deleteButtonSize: CGFloat = 15
    
    
    private lazy var photo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = imageViewCornerRadius
        return image
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: addButtonSize, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderWidth = addButtonBorderWidth
        button.layer.cornerRadius = addButtonCornerRadius
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .lightGray
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: deleteButtonSize, weight: .bold)
        button.backgroundColor = .systemRed
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        contentView.addSubview(photo)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: heightAndWidthConstant),
            deleteButton.widthAnchor.constraint(equalToConstant: heightAndWidthConstant),
            
            
        ])
    }
    func configure(with image: UIImage?) {
        photo.image = image
        addButton.removeFromSuperview()
        deleteButton.removeFromSuperview()
        addButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    func configureForEdit(with image: UIImage?) {
        photo.image = image
    }
    func setupAddPhotoButton() {
        photo.image = nil
        contentView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    
    
    
}
extension PhotoCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
