//
//  FilmImagesCollectionViewDataSource.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import Foundation
import UIKit

class FilmImagesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var images: [String]!
    
    init(images: [String]!) {
        super.init()
        self.images = images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmImageCollectionViewCell.identifier, for: indexPath) as! FilmImageCollectionViewCell
        cell.setupWithImage(images[indexPath.item])
        return cell
    }
    
    func getData() -> [String] {
        images
    }
}
