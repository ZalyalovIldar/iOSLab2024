//
//  TopListDataSource.swift
//  Movies
//
//  Created by Павел Калинин on 22.12.2024.
//
import UIKit

class TopListDataSource: NSObject, CollectionDataSourceProtocol {
    private var dataSource: [Movie]
    
    init(movies: [Movie]) {
        self.dataSource = movies
    }
    
    func updateMovies(_ newMovies: [Movie]) {
        self.dataSource = newMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.reuseIdentifier, for: indexPath) as? TopCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: dataSource[indexPath.item], index: indexPath.item)
        return cell
    }
    
    func getItemByIndex(_ index: Int) -> Movie {
        dataSource[index]
    }
    
    func getItems() -> [Movie] {
        dataSource
    }
    
    func removeAll() {
        dataSource.removeAll()
    }
}
