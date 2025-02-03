import UIKit

protocol TappedOnTopMovieDelegate: AnyObject {
    func tappedOnMovie(movie: Movie)
}

class TopMoviesDelegate: NSObject, UICollectionViewDelegate {
    
    private weak var delegate: TappedOnTopMovieDelegate?
    
    init(delegate: TappedOnTopMovieDelegate) {
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<CollectionViewSections, Movie>,
           let movie = dataSource.itemIdentifier(for: indexPath) {
            self.delegate?.tappedOnMovie(movie: movie)
        }
    }
}
