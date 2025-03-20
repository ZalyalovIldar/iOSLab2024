import UIKit

class TopMoviesCollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    private var movies: [Movie]
    var onMoviesDetail: ((Int64) -> Void)?

    init(movies: [Movie]) {
        self.movies = movies
    }
    
    func updateDataSource(movies: [Movie]) {
        self.movies = movies
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopMoviesCollectionViewCell.reuseIdentifier, for: indexPath) as! TopMoviesCollectionViewCell
        let movie = movies[indexPath.item]
        cell.configure(movie: movie, at: indexPath.item + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = movies[indexPath.item].id
        onMoviesDetail?(movieId)
    }
}
