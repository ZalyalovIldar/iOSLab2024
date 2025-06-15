//
//  CollectionViewCell.swift
//  HW_2
//
//  Created by Damir Rakhmatullin on 18.11.24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private let buttonTraillingOffset = CGFloat(-10)
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var removePhotoClosure: (() -> Void)?
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction { [weak self] _ in
            self?.removePhotoClosure?()
            print("tapped")
        }
        
        button.addAction(action, for: .touchUpInside)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
       
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupLayout()
    }
       
    func configureCell(with image: UIImage, isEdit: Bool) {
        imageView.image = image
        removeButton.isHidden = !isEdit
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            removeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            removeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: buttonTraillingOffset)
        ])
    }
}
extension CollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
