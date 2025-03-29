//
//  WatchListDataSource.swift
//  Movies
//
//  Created by Павел Калинин on 28.12.2024.
//
import UIKit

class WatchListDataSource: NSObject, CollectionDataSourceProtocol {

    private var dataSource: [Movie]
    
    init(movies: [Movie]) {
        self.dataSource = movies
    }
    
    func updateMovies(_ newMovies: [Movie]) {
        self.dataSource = newMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchListCollectionViewCell.reuseIdentifier, for: indexPath) as? WatchListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: dataSource[indexPath.item])
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
