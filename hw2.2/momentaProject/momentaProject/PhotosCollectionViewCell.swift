//
//  PhotosCollectionViewCell.swift
//  momentaProject
//
//  Created by Данил Забинский on 17.10.2024.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    private struct Constants {
        static let buttonSizeConstant: CGFloat = 25
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteImageAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.deleteImageClosure?()
        }
        let button = UIButton(configuration: .filled(), primaryAction: deleteImageAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle.fill")!, for: .normal)
        button.layer.cornerRadius = Constants.buttonSizeConstant / 2
        button.layer.masksToBounds = true
        button.tintColor = .red
        return button
    }()
    // MARK: Deleting image from collectionView closure
    var deleteImageClosure: (() -> Void)?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup with image
    func setupWithImage(_ image: UIImage, isScaleAspectFit: Bool, deleteButtonIsHidden: Bool) {
        imageView.contentMode = (isScaleAspectFit) ? .scaleAspectFit : .scaleAspectFill
        imageView.image = image
        deleteButton.isHidden = deleteButtonIsHidden
    }
    
    // MARK: Private methods
    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.buttonSizeConstant),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.buttonSizeConstant),
        ])
    }
}

// MARK: Extension to append identifier
extension PhotosCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}
