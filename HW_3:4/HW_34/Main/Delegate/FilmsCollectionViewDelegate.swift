//
//  CitiesCVDelegate.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import Foundation
import UIKit

protocol DidTapOnFilmDelegate: AnyObject {
    func didTapOnFilm(withId id: Int)
}

class FilmsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    private var dataSource: FilmsDiffableDataSource?
    private weak var delegate: DidTapOnFilmDelegate?
    
    init(dataSource: FilmsDiffableDataSource, didTapOnFilmDelegate: DidTapOnFilmDelegate) {
        self.dataSource = dataSource
        self.delegate = didTapOnFilmDelegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                cell?.transform = CGAffineTransform(scaleX: 1.025, y: 1.025)
            } completion: { _ in
                
                cell?.transform = .identity
                if let filmId = self.dataSource?.getItem(at: indexPath)?.id {
                    self.delegate?.didTapOnFilm(withId: filmId)
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            cell.transform = .identity
        }
    }
}
