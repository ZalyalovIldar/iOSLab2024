//
//  TrendFilmsDiffableDataSource.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

class TrendFilmsDiffableDataSource: NSObject {
    
    private var dataSource: UICollectionViewDiffableDataSource<CollectionViewSections, Film>?
    
    func setupPopulafFilmsCollectionView(with collectionView: UICollectionView, films: [Film], didLoadData: Bool) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
        cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
        
            cell.configurePopularFilm(film, at: indexPath.item + 1, didLoadData: didLoadData)
            
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
}
