//
//  ImagesDataSource.swift
//  Movies
//
//  Created by Павел Калинин on 24.12.2024.
//
import UIKit

class ImagesDataSource: NSObject, CollectionDataSourceProtocol {
    typealias ItemType = Image
    
    private var dataSource: [Image]
    
    init(images: [Image]) {
        self.dataSource = images
    }
    
    func updateDataSource(_ images: [Image]) {
        self.dataSource = images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as? ImagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: dataSource[indexPath.item])
        return cell
    }
    
    func getItemByIndex(_ index: Int) -> Image {
        dataSource[index]
    }
    
    func getItems() -> [Image] {
        dataSource
    }
    
    func removeAll() {
        dataSource.removeAll()
    }
}
