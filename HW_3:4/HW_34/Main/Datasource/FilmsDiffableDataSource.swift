//
//  FilmsDiffableDataSource.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

class FilmsDiffableDataSource: NSObject {
    
    private var dataSource: UICollectionViewDiffableDataSource<CollectionViewSections, Film>?
    
    func setupFilmsCollectionView(with collectionView: UICollectionView, films: [Film]) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
        cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
        
            cell.configureFilm(film)
            
            return cell
        })
        applySnapshot(with: films)
    }
    
    func getItem(at index: IndexPath) -> Film? {
        let item = dataSource?.itemIdentifier(for: index)
        return item
    }
    
    func applySnapshot(with films: [Film]) {
        var snapsot = NSDiffableDataSourceSnapshot<CollectionViewSections, Film>()
        
        snapsot.appendSections([.main])
        snapsot.appendItems(films)
        
        dataSource?.apply(snapsot, animatingDifferences: true)
    }
    
    func applySnapshotWithoutCreating(with films: [Film]) {
        guard var snapsot = dataSource?.snapshot() else { return }
        
        snapsot.appendItems(films)
        
        dataSource?.apply(snapsot, animatingDifferences: false)
    }
}
