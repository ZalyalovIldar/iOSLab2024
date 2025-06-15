//
//  CitiesCVDelegate.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 26.12.2024.
//

import Foundation
import UIKit

protocol DidTapOnFilmDelegate: AnyObject {
    func didTapOnFilm(withId id: Int)
}

class FilmsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    private var dataSource: CollectionViewDiffableDataSource?
    private weak var delegate: DidTapOnFilmDelegate?
    
    init(dataSource: CollectionViewDiffableDataSource, didTapOnFilmDelegate: DidTapOnFilmDelegate) {
        self.dataSource = dataSource
        self.delegate = didTapOnFilmDelegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.125, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.125) {
                    cell.transform = .identity
                } completion: { _ in
                    if let filmId = self.dataSource?.getItem(at: indexPath)?.id {
                        self.delegate?.didTapOnFilm(withId: filmId)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.33) {
            cell.transform = .identity
        }
    }
}
