//
//  HeaderCollectionViewDataSource.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 05.01.2025.
//

import Foundation
import UIKit

class HeaderCollectionViewDataSource: NSObject {
    
    var dataSource: UICollectionViewDiffableDataSource<CollectionSection, MovieImages>?
    
    init(collectionView: UICollectionView, images: [MovieImages]) {
        super.init()
        setupDataSource(collectionView: collectionView)
        applySnapshot(images: images, animated: true)
    }
    
    private func setupDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<CollectionSection, MovieImages>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, movieImages in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.reuseIdentifier, for: indexPath) as! HeaderCollectionViewCell
                let imageURL = movieImages.image
                cell.configureCell(imageURL: imageURL)
                return cell
        })
    }
    
    func applySnapshot(images: [MovieImages], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionSection,MovieImages>()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
}
