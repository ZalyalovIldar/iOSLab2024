//
//  CollectionViewDelegate.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import Foundation
import UIKit

protocol SelectedMovieDelegate: AnyObject {
    func pushDetailView(movieId: Int)
}

class MoviesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    private weak var delegate: SelectedMovieDelegate?
    private var collectionDataSource: CollectionViewDiffableDataSource?
    
    init(dataSource: CollectionViewDiffableDataSource? = nil, delegate: SelectedMovieDelegate? = nil) {
        self.delegate = delegate
        self.collectionDataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        collectionView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { isFinished in
            guard isFinished else { return }
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            } completion: { isFinished in
                guard isFinished else { return }
                if let dataSource = self.collectionDataSource?.dataSource,
                   let movie = dataSource.itemIdentifier(for: indexPath) {
                    self.delegate?.pushDetailView(movieId: movie.id)
                }
                collectionView.isUserInteractionEnabled = true
            }
        }
    }
}
