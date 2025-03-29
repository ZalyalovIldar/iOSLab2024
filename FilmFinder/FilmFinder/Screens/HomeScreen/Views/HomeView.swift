//
//  HomeView.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 30.12.2024.
//

import UIKit

class HomeView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var failedAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        return alert
    }()
    
    lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var titleLabelNavigationItem: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Bold", size: Constant.Font.large)
        label.textColor = .white
        return label
    }()
    
    lazy var topMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.41, height: UIScreen.main.bounds.height * 0.28)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopMovieCollectionViewCell.self, forCellWithReuseIdentifier: TopMovieCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    lazy var cityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    lazy var listMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    var heightListMoviesCollectionViewConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = Color.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(searchBar)
        contentView.addSubview(topMoviesCollectionView)
        contentView.addSubview(cityCollectionView)
        contentView.addSubview(listMoviesCollectionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Constraint.marginHuge),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginHuge),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginHuge),
            searchBar.heightAnchor.constraint(equalToConstant: Constant.Constraint.marginHeight),
            
            topMoviesCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Constant.Constraint.marginHuge),
            topMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginHuge),
            topMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginHuge),
            topMoviesCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.28),
            
            cityCollectionView.topAnchor.constraint(equalTo: topMoviesCollectionView.bottomAnchor, constant: Constant.Constraint.marginHuge),
            cityCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginHuge),
            cityCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginHuge),
            cityCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06),
            
            listMoviesCollectionView.topAnchor.constraint(equalTo: cityCollectionView.bottomAnchor, constant: Constant.Constraint.marginHuge),
            listMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginHuge),
            listMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginHuge),
            listMoviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Constraint.marginHuge),
            
        ])
    }
    
    func setCollectionViewHeight(height: CGFloat) {
        heightListMoviesCollectionViewConstraint?.isActive = false
            
        heightListMoviesCollectionViewConstraint = listMoviesCollectionView.heightAnchor.constraint(equalToConstant: height)
        heightListMoviesCollectionViewConstraint?.isActive = true
    }
    
    func configureSearchBar(placeholder: String, icon: UIImage) {
        self.searchBar.setupPlaceholder(placeholder: placeholder)
        self.searchBar.setupIcon(icon: icon)
    }
}
