//
//  HomeView.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

protocol CitySelectionDelegate: AnyObject {
    func selectCity(at index: Int)
}

protocol MovieSearchDelegate: AnyObject {
    func findMovie(withTitle name: String)
}

protocol RefreshMoviesDelegate: AnyObject {
    func reloadMovies()
}

class MainScreenView: UIView {
    
    private lazy var movieNotFoundAlert: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: "Фильм с таким названием не найден", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Ок", style: .destructive)
        alert.addAction(confirmAction)
        return alert
    }()
    
    private weak var cityDelegate: CitySelectionDelegate?
    private weak var movieSearchDelegate: MovieSearchDelegate?
    private weak var movieRefreshDelegate: RefreshMoviesDelegate?
    
    private lazy var hideKeyboardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.endEditing(true)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollContainer: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = Colors.backgroud
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var searchInput: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Найти фильм"
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .systemGray6
        searchBar.searchTextField.backgroundColor = Colors.secondaryBG
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = Colors.secondaryBG
        searchBar.searchTextField.textColor = .systemGray6
        return searchBar
    }()
    
    lazy var trendingMoviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: SpacingConstants.width / 2.25, height: SpacingConstants.width / 1.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = SpacingConstants.small
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.backgroud
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var cityListCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = SpacingConstants.small / 2
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = SpacingConstants.small / 2
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.backgroud
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var moviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: SpacingConstants.width / 3.5, height: SpacingConstants.width / 2.25)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = SpacingConstants.small / 2
        layout.minimumLineSpacing = SpacingConstants.small
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = SpacingConstants.small
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        collectionView.backgroundColor = Colors.backgroud
        return collectionView
    }()
    
    private lazy var showMoreFilmsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = SpacingConstants.small / 2
        button.setTitle("Показать еще", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: SpacingConstants.medium).isActive = true
        return button
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            searchInput,
            trendingMoviesCollection,
            cityListCollection,
            moviesCollection,
            showMoreFilmsButton
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = SpacingConstants.small
        return stack
    }()

    init(cityDelegate: CitySelectionDelegate, movieSearchDelegate: MovieSearchDelegate) {
        super.init(frame: .zero)
        self.cityDelegate = cityDelegate
        self.movieSearchDelegate = movieSearchDelegate
        backgroundColor = Colors.backgroud
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideShowMoreFilmsButton() { showMoreFilmsButton.isHidden = true }
    func showShowMoreFilmsButton() { showMoreFilmsButton.isHidden = false }
    
    func setActionToShowMoreFilmsButton(action: UIAction) {
        showMoreFilmsButton.addAction(action, for: .touchUpInside)
    }
    
    func setMoviesDelegate(delegate: UICollectionViewDelegate) {
        moviesCollection.delegate = delegate
    }
    
    func getTrendingMoviesCollectionView() -> UICollectionView {
        trendingMoviesCollection
    }
    
    func setCityListDataSource(dataSource: UICollectionViewDataSource) {
        cityListCollection.dataSource = dataSource
    }
    
    func getMoviesCollectionView() -> UICollectionView {
        moviesCollection
    }
    
    func getMovieNotFoundAlert() -> UIAlertController {
        movieNotFoundAlert
    }
    
    private func configureView() {
        addSubview(scrollContainer)
        
        scrollContainer.addSubview(hideKeyboardButton)
        scrollContainer.addSubview(contentStack)
        NSLayoutConstraint.activate([
            scrollContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            hideKeyboardButton.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            hideKeyboardButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            hideKeyboardButton.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            hideKeyboardButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.9),
            
            trendingMoviesCollection.heightAnchor.constraint(equalToConstant: SpacingConstants.width / 1.5),
            cityListCollection.heightAnchor.constraint(equalToConstant: SpacingConstants.big),
            moviesCollection.heightAnchor.constraint(equalToConstant: (SpacingConstants.width / 2.25 + SpacingConstants.small) * 7),
        ])
    }
}

extension MainScreenView: UICollectionViewDelegate, UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cityDelegate?.selectCity(at: indexPath.item)
        cityListCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let movieName = searchBar.text {
            movieSearchDelegate?.findMovie(withTitle: movieName)
        }
    }
}

