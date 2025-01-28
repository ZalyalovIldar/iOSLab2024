import Foundation
import UIKit

class MovieSnapsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var images: [String]!
    
    init(images: [String]!) {
        super.init()
        self.images = images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSnapsCollectionViewCell.identifier, for: indexPath) as! MovieSnapsCollectionViewCell
        cell.setupWithImage(images[indexPath.item])
        return cell
    }
    
    func getData() -> [String] {
        images
    }
}
