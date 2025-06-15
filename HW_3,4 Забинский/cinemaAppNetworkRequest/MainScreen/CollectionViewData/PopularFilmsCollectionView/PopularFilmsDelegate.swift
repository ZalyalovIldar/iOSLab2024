//
//  PopularFilmsDelegate.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 09.01.2025.
//

import UIKit

protocol DidTapOnPopularFilmDelegate: AnyObject {
    func didTapOnFilm(film: Film)
}

class PopularFilmsDelegate: NSObject, UICollectionViewDelegate {
    
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
