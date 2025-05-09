//
//  CitiesCollectionViewDelegate.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import Foundation
import UIKit

protocol CitySelectionDelegate: AnyObject {
    func didSelectedCity(city: City)
}

class CitiesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    private weak var delegate: CitySelectionDelegate?
    
    init(delegate: CitySelectionDelegate? = nil) {
        self.delegate = delegate
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
                if let dataSource = collectionView.dataSource as? CollectionViewDataSource {
                    let city = dataSource.cities[indexPath.item]
                    self.delegate?.didSelectedCity(city: city)
                }
                collectionView.isUserInteractionEnabled = true
            }
        }
    }
}
