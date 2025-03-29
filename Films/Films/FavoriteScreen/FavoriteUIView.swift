//
//  FavoriteUIView.swift
//  Films
//
//  Created by Артур Мавликаев on 16.01.2025.
//

import UIKit

class FavoriteUIView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        addSubview(collectionView)
        setupCollectionConstraints()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let numberOfItemsPerRow: CGFloat = 3
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + (layout.minimumInteritemSpacing * (numberOfItemsPerRow - 1))
        let availableWidth = UIScreen.main.bounds.width - totalSpacing
        let itemWidth = floor(availableWidth / numberOfItemsPerRow)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: "FilmCell")

        return cv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
