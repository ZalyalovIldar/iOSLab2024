//
//  CollectionViewDiffableDataSource.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 31.12.2024.
//

import Foundation
import UIKit

protocol CollectionViewDiffableDataSourceDelegate: AnyObject {
    func configureCell(cell: UICollectionViewCell, movie: Movie, indexPath: IndexPath)
}

class CollectionViewDiffableDataSource: NSObject {
    private weak var delegate: CollectionViewDiffableDataSourceDelegate?
    var dataSource: UICollectionViewDiffableDataSource<CollectionSection, Movie>?
    
    init(collectionView: UICollectionView,
         cellIdentifier: String, delegate: CollectionViewDiffableDataSourceDelegate) {
        self.delegate = delegate
        super.init()
        setupDataSource(collectionView: collectionView, cellIdentifier: cellIdentifier)
    }
    
    private func setupDataSource(
        collectionView: UICollectionView,
        cellIdentifier: String) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            self.delegate?.configureCell(cell: cell, movie: movie, indexPath: indexPath)
            return cell
        })
    }
    
    func updateSnapshot(movies: [Movie], animated: Bool) {
        var snapshot = dataSource?.snapshot() ?? NSDiffableDataSourceSnapshot<CollectionSection, Movie>()
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
    
    func applySnapshot(movies: [Movie], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionSection, Movie>()
        snapshot.appendSections([CollectionSection.main])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
}
