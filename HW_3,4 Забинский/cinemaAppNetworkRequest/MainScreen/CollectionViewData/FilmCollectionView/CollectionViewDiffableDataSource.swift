//
//  CollectionViewDiffableDataSource.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 24.12.2024.
//

import Foundation
import UIKit

class CollectionViewDiffableDataSource: NSObject {
    
    private var dataSource: UICollectionViewDiffableDataSource<CollectionViewSections, Film>?
    
    func setupPopulafFilmsCollectionView(with collectionView: UICollectionView, films: [Film], didLoadData: Bool) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
        cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
            
            cell.configurePopularFilm(film, at: indexPath.item + 1, didLoadData: didLoadData)
            
            return cell
        })
        applyPopularFilmsSnapshot(with: films)
    }
    
    func setupFilmsCollectionView(with collectionView: UICollectionView, films: [Film]) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
        cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
            
            cell.configureFilm(film)
            
            return cell
        })
        applyDefaultFilmsSnapshot(with: films)
    }
    
    func getItem(at index: IndexPath) -> Film? {
        dataSource?.itemIdentifier(for: index)
    }
    
    func applyPopularFilmsSnapshot(with films: [Film]) {
        var snapsot = NSDiffableDataSourceSnapshot<CollectionViewSections, Film>()
        
        snapsot.appendSections([.popularFilms])
        snapsot.appendItems(films)
        
        dataSource?.apply(snapsot, animatingDifferences: false)
    }
    
    func applyDefaultFilmsSnapshot(with films: [Film]) {
        var snapsot = NSDiffableDataSourceSnapshot<CollectionViewSections, Film>()
        
        snapsot.appendSections([.defaultFilms])
        snapsot.appendItems(films)
        
        dataSource?.apply(snapsot, animatingDifferences: true)
    }
}
