import UIKit

class ImageCarouselCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var dataSource: [Images]
    
    init(dataSource: [Images]) {
        self.dataSource = dataSource
    }
    
    func updateDataSource(dataSource: [Images]) {
        self.dataSource = dataSource
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCarouselCollectionViewCell.reuseIndetifier, for: indexPath) as! ImageCarouselCollectionViewCell
        let images = dataSource[indexPath.item]
        cell.configure(images: images)
        return cell
    }
}
