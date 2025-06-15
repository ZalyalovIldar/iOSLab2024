//
//  ImagesCollectionView.swift
//  Movies
//
//  Created by Павел Калинин on 25.12.2024.
//

import UIKit

class ImagesCollectionView: UIView {
    var pagers: [UIView] = []
    var currentPage = 0
    var pagerWidthAnchor: NSLayoutConstraint?
    
    lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 210)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppColors.mainColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollection() {
        addSubview(imagesCollectionView)
        
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupController() {
        let countItems = (imagesCollectionView.dataSource as! (any CollectionDataSourceProtocol)).getItems().count
        
        guard countItems > 1 else { return }
        let pagersStack: UIStackView = {
            let pagersStack = UIStackView()
            pagersStack.axis = .horizontal
            pagersStack.distribution = .equalSpacing
            pagersStack.spacing = 5
            pagersStack.translatesAutoresizingMaskIntoConstraints = false
            return pagersStack
        }()
        
        for tag in 1...countItems {
            let pager = UIView()
            pager.tag = tag
            pager.translatesAutoresizingMaskIntoConstraints = false
            pager.backgroundColor = .white
            pager.layer.cornerRadius = 5
            pager.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pagerTapped)))
            self.pagers.append(pager)
            pagersStack.addArrangedSubview(pager)
        }
        
        addSubview(pagersStack)
            
        NSLayoutConstraint.activate([
            pagersStack.topAnchor.constraint(equalTo: imagesCollectionView.topAnchor, constant: 5),
            pagersStack.centerXAnchor.constraint(equalTo: imagesCollectionView.centerXAnchor)
        ])
    }
    
    @objc
    private func pagerTapped(sender: UIGestureRecognizer) {
        if let index = sender.view?.tag {
            imagesCollectionView.scrollToItem(at: IndexPath(item: index - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
