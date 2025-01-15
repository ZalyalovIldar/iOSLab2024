//
//  FavoritesViewController.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var favoriteMovies: [MovieEntity] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        loadFavoriteMovies()
    }
    
    private func loadFavoriteMovies() {
        favoriteMovies = CoreDataManager.shared.fetchMovies().filter { $0.isFavorite }
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCell", for: indexPath)
        return cell
    }
}
