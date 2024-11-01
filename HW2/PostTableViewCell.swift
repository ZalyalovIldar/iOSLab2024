//
//  PostTableViewCell.swift
//  HW2
//
//  Created by Терёхин Иван on 22.10.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell, UICollectionViewDelegate {
    
    private var images: [UIImage] = []
    
    private let stackSpacing: CGFloat = 10
    private let stackTopAnchorConstant: CGFloat = 8
    private let stackLeadingAnchorConstant: CGFloat = 16
    private let stackTrailingAnchorConstant: CGFloat = -16
    private let photosHeightAnchorConstant: CGFloat = 200
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mainStack: UIStackView = {
        
        let stack = UIStackView(arrangedSubviews: [title, data, text, photos])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = stackSpacing
        return stack
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 1
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 17, weight: .bold)
        
        return title
    }()
    
    private lazy var data: UILabel = {
        let data = UILabel()
        data.textColor = .secondaryLabel
        data.font = .systemFont(ofSize: 12)
        data.textAlignment = .center
        data.translatesAutoresizingMaskIntoConstraints = false
        return data
        
    }()
    
    
    private lazy var text: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 5
        
        return text
    }()
    
    private lazy var photos: UICollectionView = {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = CGSize(width: min(screenWidth, screenHeight) * 0.47, height: min(screenWidth, screenHeight) * 2)
    
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
        
    }()
    
    private func setupLayout() {
        
        contentView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: stackTopAnchorConstant),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: stackLeadingAnchorConstant),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: stackTrailingAnchorConstant),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photos.heightAnchor.constraint(equalToConstant: photosHeightAnchorConstant)
        
    
        ])
        
        
    }
    
    func configure(with posts: Post) {
        text.text = posts.text
        data.text = Post.createData(with: posts.data)
        title.text = posts.title
        self.images = posts.photos
    }
}

extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,  numberOfItemsInSection section: Int) -> Int {
        return min(images.count, 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
}
        
extension PostTableViewCell {
    static var reuseIndentifier: String {
        return String(describing: self)
    }
}
