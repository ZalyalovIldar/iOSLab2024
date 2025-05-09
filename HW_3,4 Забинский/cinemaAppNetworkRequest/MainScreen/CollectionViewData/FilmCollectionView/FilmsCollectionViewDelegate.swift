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
    private weak var delegate: DidTapOnFilmDelegate?
    
    init(didTapOnFilmDelegate: DidTapOnFilmDelegate) {
        self.delegate = didTapOnFilmDelegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        if let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<CollectionViewSections, Film> {
            UIView.animate(withDuration: 0.125, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { isFinished in
                if isFinished {
                    UIView.animate(withDuration: 0.125) {
                        cell.transform = .identity
                    } completion: { _ in
                        if let filmId = dataSource.itemIdentifier(for: indexPath)?.id {
                            self.delegate?.didTapOnFilm(withId: filmId)
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        let rotationTransform = CGAffineTransform(rotationAngle: .pi / 12)
        let scaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let mixedTransform = rotationTransform.concatenating(scaleTransform)
        cell.transform = mixedTransform
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            cell.alpha = 0.75
            cell.transform = CGAffineTransform(rotationAngle: .pi / -24).concatenating(scaleTransform)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }
}
