//
//  ThirdSectionTableViewCell.swift
//  UserSummary
//
//  Created by Тагир Файрушин on 27.09.2024.
//

import UIKit

class ThirdSectionTableViewCell: UITableViewCell {
   
    lazy var titleHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 350)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true // Включаем постраничную прокрутку
        collectionView.decelerationRate = .fast // Устанавливаю скорость замедления при прокрутке на высокую, чтобы прокрутка останавливалась быстрее
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var photos = [UIImage?](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleHeaderLabel)
        contentView.addSubview(collectionView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleHeaderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleHeaderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleHeaderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: titleHeaderLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 350) // Высота 300
        ])
    }
    
}
extension ThirdSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
        
        cell.photoImageView.image = photos[indexPath.item]
        return cell
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
