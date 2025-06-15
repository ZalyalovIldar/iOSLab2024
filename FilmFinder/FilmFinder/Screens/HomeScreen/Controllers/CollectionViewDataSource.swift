//
//  CollectionViewDataSource.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import Foundation
import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    let cities: [City]
    var selectedCity: City?
    
    init(cities: [City]) {
        self.cities = cities
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.reuseIdentifier, for: indexPath) as! CityCollectionViewCell
        cell.configureCell(city: cities[indexPath.item])
        cell.underlineText(state: selectedCity == cities[indexPath.item])
        return cell
    }
}
