//
//  AllMoviesDataSource.swift
//  Movies
//
//  Created by Павел Калинин on 23.12.2024.
//
import UIKit

class AllMoviesDataSource: NSObject, CollectionDataSourceProtocol {
    
    private var allMovies: [Movie] = []
    
    init(allMovies: [Movie]) {
        self.allMovies = allMovies
    }
    
    func updateDataSource(with movies: [Movie]) {
        self.allMovies = movies
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: allMovies[indexPath.item])
        return cell
    }
    
    func getItemByIndex(_ index: Int) -> Movie {
        allMovies[index]
    }
    
    func getItems() -> [Movie] {
        allMovies
    }
    
    func addItems(_ items: [Movie]) {
        allMovies += items
    }
    
    func removeAll() {
        allMovies.removeAll()
    }
}
