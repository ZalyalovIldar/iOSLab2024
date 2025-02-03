import Foundation
import UIKit

class CollectionViewDiffableDataSource: NSObject {
    
    private var dataSource: UICollectionViewDiffableDataSource<CollectionViewSections, Movie>?
    
    func setupTopMoviesCollectionView(with collectionView: UICollectionView, movies: [Movie], didLoadData: Bool) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
        cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            
            cell.configureTopMovie(film, at: indexPath.item + 1, didLoadData: didLoadData)
            
            return cell
        })
        applyTopMoviesSnapshot(with: movies)
    }
    
    func setupMoviesCollectionView(with collectionView: UICollectionView, movies: [Movie]) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
        cellProvider: { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            
            cell.configureMovie(movie)
            
            return cell
        })
        applyDefaultMoviesSnapshot(with: movies, shouldCreateSnapshot: true)
    }
    
    func applyTopMoviesSnapshot(with movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSections, Movie>()
        
        snapshot.appendSections([.popularFilms])
        snapshot.appendItems(movies)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func applyDefaultMoviesSnapshot(with movies: [Movie], shouldCreateSnapshot: Bool) {
        var snapshot: NSDiffableDataSourceSnapshot<CollectionViewSections, Movie>!
        if shouldCreateSnapshot {
            snapshot = NSDiffableDataSourceSnapshot<CollectionViewSections, Movie>()
            snapshot?.appendSections([.defaultFilms])
        } else {
            snapshot = dataSource!.snapshot()
        }
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

