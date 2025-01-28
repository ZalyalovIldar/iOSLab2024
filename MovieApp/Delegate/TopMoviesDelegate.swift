//
//  PopularFilmsDelegate.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

import UIKit

protocol DidTapOnPopularFilmDelegate: AnyObject {
    func didTapOnFilm(film: Film)
}

class TopMoviesDelegate: NSObject, UICollectionViewDelegate {
    
    private weak var delegate: DidTapOnPopularFilmDelegate?
    
    init(delegate: DidTapOnPopularFilmDelegate) {
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<CollectionViewSections, Film>,
           let film = dataSource.itemIdentifier(for: indexPath) {
            self.delegate?.didTapOnFilm(film: film)
        }
    }
}
