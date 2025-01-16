//
//  TableViewCell.swift
//  HW_2
//
//  Created by Damir Rakhmatullin on 15.11.24.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private final var maxImagesInCellConstant = 3
    
    enum SectionCollectionCell {
        case main
    }

    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    lazy var about: UILabel = {
        let about = UILabel()
        about.numberOfLines = 5
        about.translatesAutoresizingMaskIntoConstraints = false
        return about
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, date, about])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    private let dateFormater: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy HH:mm"
           return formatter
       }()
    
    private var collectionViewWithPhotos: UICollectionView?
    
    private var dataSourceCollection: UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    func configureCell(with model: Post) {
        title.text = model.title
        about.text = model.text
        date.text = dateFormater.string(from: model.date)
        photos = model.images
    }
    
    private var photos: [UIImage]? {
           didSet{
               if let images = photos, !images.isEmpty {
                   addCollectionView(with: images)
               } else {
                   removeCollectionView()
               }
           }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeCollectionView()
    }
    
    private func addCollectionView(with photos: [UIImage]) {
        guard collectionViewWithPhotos == nil else {return}
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
       
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionViewWithPhotos = collectionView
        
        verticalStackView.insertArrangedSubview(collectionView, at: 0)
        if (photos.count > maxImagesInCellConstant) {
            let photosToView = Array(photos[0...1])
            configureCollectionDataSource(for: collectionView, with: photosToView)
        }
        if(photos.count != 0) {
            configureCollectionDataSource(for: collectionView, with: photos)
        }
   
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])

    }
    
    private func configureCollectionDataSource(for collectionView: UICollectionView, with photos: [UIImage]) {
        dataSourceCollection = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
            cell.configureCell(with: image, isEdit: false)
            return cell
        })
        updateDataSourceCollection(with: photos, animated: false)
    }
    

    private func updateDataSourceCollection(with photos: [UIImage], animated: Bool) {
           var snapshot = NSDiffableDataSourceSnapshot<SectionCollectionCell, UIImage>()
           snapshot.appendSections([.main])
           snapshot.appendItems(photos)
           dataSourceCollection?.apply(snapshot, animatingDifferences: animated)
    }
    
    private func setupLayout() {
        contentView.addSubview(verticalStackView)
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func removeCollectionView() {
        if let collectionView = collectionViewWithPhotos {
            verticalStackView.removeArrangedSubview(collectionView)
            collectionView.removeFromSuperview()
            collectionViewWithPhotos = nil
        }
    }

}


extension TableViewCell {
     static var reuseIdentifier: String {
         return String(describing: self)
     }
 }

