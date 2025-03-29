//
//  MovieCollectionDataSource.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import UIKit

class MovieCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    private var movies: [Movie]
    private var isTopMovies: Bool
    
    init(movies: [Movie], isTopMovies: Bool = false) {
        self.movies = movies
        self.isTopMovies = isTopMovies
    }
    
    func updateDataSource(with movies: [Movie]) {
        self.movies = movies
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let movie = movies[indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.configure(with: movie, number: indexPath.item + 1, isTopMovie: isTopMovies) // Передаем флаг isTopMovies
            return cell
        }

    
    func getItems() -> [Movie] {
        return movies
    }
    
    func getItem(at index: Int) -> Movie {
        return movies[index]
    }
}

