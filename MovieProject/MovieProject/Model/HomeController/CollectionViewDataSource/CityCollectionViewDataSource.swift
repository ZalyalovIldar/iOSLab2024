import UIKit

class CityCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    private var dataSource: [City]
    var onClickCityCell: ((String) -> Void)?
    
    init(dataSource: [City] ) {
        self.dataSource = dataSource
    }
    
    func updateDataSource(with cities: [City]) {
        self.dataSource = cities
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionVIewCell.reuseIndentifier, for: indexPath) as! CityCollectionVIewCell
        let city = dataSource[indexPath.item]
        cell.configureCell(with: city)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let city = dataSource[indexPath.item].slug
        onClickCityCell?(city)
    }
}
