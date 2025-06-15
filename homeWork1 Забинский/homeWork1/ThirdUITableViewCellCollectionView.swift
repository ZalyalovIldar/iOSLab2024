//
//  ThirdUITableViewCellCollectionViewTableViewCell.swift
//  homeWork1
//
//  Created by Данил Забинский on 29.09.2024.
//

import UIKit

import UIKit

class ThirdUITableViewCellCollectionView: UITableViewCell {
    // MARK: - DataSource
    private var dataSource: [UIImage] = []
    
    // MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = setupFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPrefetchingEnabled = true
        collectionView.isSpringLoaded = true
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configureWithUser(from user: User) {
        dataSource = user.information
    }
    
    // MARK: - Private Methods
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func setup() {
        setupAppearance()
        
        setupHeaderLabelText()
        
        activateConstraints()
    }
    
    private func setupAppearance() {
        contentView.backgroundColor = .systemGray4
        contentView.layer.cornerRadius = 25
        collectionView.backgroundColor = .systemGray6.withAlphaComponent(0.35)
    }
    
    private func setupHeaderLabelText() {
        headerLabel.text = "Портфолио"
    }
    
    private func activateConstraints() {
        contentView.addSubview(collectionView)
        contentView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            collectionView.heightAnchor.constraint(equalToConstant: 145),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -35)
        ])
        
    }
}

// MARK: - Implementing Protocol Extension
extension ThirdUITableViewCellCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as! ImageViewCell
        
        cell.configureWithImage(from: dataSource[indexPath.item])
        
        return cell
    }
}

// MARK: - Adding identifier property Extension
extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}


class ImageViewCell: UICollectionViewCell {
    // MARK: - Properties
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configureWithImage(from image: UIImage) {
        imageView.image = image
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 125),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
