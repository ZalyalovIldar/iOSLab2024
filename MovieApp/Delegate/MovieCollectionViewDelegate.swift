import Foundation
import UIKit

protocol TappedOnMovieDelegate: AnyObject {
    func tappedOnMovie(withId id: Int)
}

class MovieCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    private weak var delegate: TappedOnMovieDelegate?
    
    init(tappedOnMovieDelegate: TappedOnMovieDelegate) {
        self.delegate = tappedOnMovieDelegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        if let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<CollectionViewSections, Movie> {
            UIView.animate(withDuration: 0.125, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { isFinished in
                if isFinished {
                    UIView.animate(withDuration: 0.125) {
                        cell.transform = .identity
                    } completion: { _ in
                        if let movieId = dataSource.itemIdentifier(for: indexPath)?.id {
                            self.delegate?.tappedOnMovie(withId: movieId)
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        let rotationTransform = CGAffineTransform(rotationAngle: .pi / 12)
        let scaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let mixedTransform = rotationTransform.concatenating(scaleTransform)
        cell.transform = mixedTransform
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            cell.alpha = 0.75
            cell.transform = CGAffineTransform(rotationAngle: .pi / -24).concatenating(scaleTransform)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }
}
