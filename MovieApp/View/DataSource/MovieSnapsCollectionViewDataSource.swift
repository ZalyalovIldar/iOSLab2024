//
//  FilmImagesCollectionViewDataSource.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmImageCollectionViewCell.identifier, for: indexPath) as! FilmImageCollectionViewCell
        cell.setupWithImage(images[indexPath.item])
        return cell
    }
    
    func getData() -> [String] {
        images
    }
}
