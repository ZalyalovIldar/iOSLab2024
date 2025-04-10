import UIKit

class AllMoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    private var dataSource: [Movie]
    var onMoviesDetail: ((Int64) -> Void)?
    
    init(dataSource: [Movie]) {
        self.dataSource = dataSource
    }
    
    func updateDataSource(with movies: [Movie]) {
        self.dataSource = movies
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.reuseIndentifier, for: indexPath) as! MoviesCollectionViewCell
        let movie = dataSource[indexPath.item]
        cell.configureCell(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = dataSource[indexPath.item].id
        onMoviesDetail?(movieId)
        
    }
}
