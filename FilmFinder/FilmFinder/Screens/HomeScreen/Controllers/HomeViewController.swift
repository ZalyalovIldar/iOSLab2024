//
//  HomeViewController.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 30.12.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var homeView: HomeView {
        self.view as! HomeView
    }
    
    private var topMoviesCollectionViewDelegate: MoviesCollectionViewDelegate?
    private var cityCollectionViewDelegate: CitiesCollectionViewDelegate?
    private var listMoviesCollectionViewDelegate: MoviesCollectionViewDelegate?
    private var topMoviesCollectionViewDiffableDataSource: CollectionViewDiffableDataSource?
    private var listMoviesCollectioViewDiffableDataSource: CollectionViewDiffableDataSource?
    private var collectionViewDataSource: CollectionViewDataSource?
    private var modelManager: HomeModelManager = HomeModelManager()
    private var moviesSelectedCity: [Movie]?
    
    override func loadView() {
        super.loadView()
        self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.scrollView.delegate = self
        setupTopMoviesCollectionView()
        setupCitiesCollectionView()
        setupListMoviesCollectionView()
        homeView.searchBar.setupDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureHomeView()
        configureNavigationBar()
    }
    
    private func setupTopMoviesCollectionView() {
        topMoviesCollectionViewDiffableDataSource = CollectionViewDiffableDataSource(
            collectionView: homeView.topMoviesCollectionView,
            cellIdentifier: TopMovieCollectionViewCell.reuseIdentifier,
            delegate: self)
        
        topMoviesCollectionViewDelegate = MoviesCollectionViewDelegate(dataSource: topMoviesCollectionViewDiffableDataSource, delegate: self)
        homeView.topMoviesCollectionView.delegate = topMoviesCollectionViewDelegate
        
        let topMovies = modelManager.obtainTopMovies()
        
        topMoviesCollectionViewDiffableDataSource?.applySnapshot(movies: topMovies, animated: true)
        
    }
    
    private func setupListMoviesCollectionView() {
        listMoviesCollectioViewDiffableDataSource = CollectionViewDiffableDataSource(
            collectionView: homeView.listMoviesCollectionView,
            cellIdentifier: MovieCollectionViewCell.reuseIdentifier,
            delegate: self)
        
        listMoviesCollectionViewDelegate = MoviesCollectionViewDelegate(dataSource: listMoviesCollectioViewDiffableDataSource, delegate: self)
        homeView.listMoviesCollectionView.delegate = listMoviesCollectionViewDelegate
        
        listMoviesCollectioViewDiffableDataSource?.applySnapshot(movies: modelManager.obtainAllMovies(), animated: true)
        calculateCollectionViewHeight(itemsCount: modelManager.countMovies)
        
    }
    
    private func setupCitiesCollectionView() {
        Task {
            let cities = modelManager.obtainAllCities()
            collectionViewDataSource = CollectionViewDataSource(cities: cities)
            
            homeView.cityCollectionView.dataSource = collectionViewDataSource
            
            cityCollectionViewDelegate = CitiesCollectionViewDelegate(delegate: self)
            homeView.cityCollectionView.delegate = cityCollectionViewDelegate

        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = Color.backgroundColor
        let leftTitleItem = UIBarButtonItem(customView: homeView.titleLabelNavigationItem)
        homeView.titleLabelNavigationItem.text = modelManager.getTextNavigationBar()
        navigationItem.leftBarButtonItem = leftTitleItem
    }
    
    private func configureHomeView() {
        self.homeView.configureSearchBar(placeholder: modelManager.getTextFieldPlaceholder(), icon: modelManager.getTextFieldIcon())
        configureAlert()
    }
    
    private func configureAlert() {
        homeView.failedAlert.title = modelManager.getAlertTitle()
        homeView.failedAlert.message = modelManager.getAlertMessage()
        let okeyAction = UIAlertAction(title: "ок", style: .default)
        homeView.failedAlert.addAction(okeyAction)
    }
    
    private func calculateCollectionViewHeight(itemsCount: Int) {
        let quantityItems = itemsCount
        let numberOfRows = quantityItems % 3 == 0 ? quantityItems / 3 : (quantityItems + 1) / 3
        let updatedHeight = UIScreen.main.bounds.height * 0.2 * CGFloat(numberOfRows)
        homeView.setCollectionViewHeight(height: updatedHeight)
    }
}

extension HomeViewController: CollectionViewDiffableDataSourceDelegate {
    func configureCell(cell: UICollectionViewCell, movie: Movie, indexPath: IndexPath) {
        if let cell = cell as? TopMovieCollectionViewCell {
            
            cell.configureCell(imageURL: movie.poster.image, imageData: movie.dataImage, index: indexPath.item + 1)
            
        } else {
            let cell = cell as! MovieCollectionViewCell
            cell.configureCell(imageURL: movie.poster.image)
        }
    }
}

extension HomeViewController: CitySelectionDelegate {
    
    func didSelectedCity(city: City) {
        if collectionViewDataSource?.selectedCity == city {
            collectionViewDataSource?.selectedCity = nil
            listMoviesCollectioViewDiffableDataSource?.applySnapshot(movies: modelManager.obtainAllMovies(), animated: true)
            calculateCollectionViewHeight(itemsCount: modelManager.countMovies)
            modelManager.countMovies = modelManager.obtainAllCities().count
            modelManager.nextPage = 2
        } else {
            collectionViewDataSource?.selectedCity = city
            Task {
                moviesSelectedCity = await modelManager.obtainMovies(forCity: city)
                modelManager.countMovies = moviesSelectedCity!.count
                listMoviesCollectioViewDiffableDataSource?.applySnapshot(movies: moviesSelectedCity!, animated: true)
                calculateCollectionViewHeight(itemsCount: modelManager.countMovies)
            }
        }
        homeView.cityCollectionView.reloadData()
    }
}

extension HomeViewController: SelectedMovieDelegate {
    func pushDetailView(movieId: Int) {
        let detailViewController = DetailViewController(id: movieId)
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let moviesSelectedCity = moviesSelectedCity {
            for movie in moviesSelectedCity {
                if movie.title == textField.text {
                    self.present(DetailViewController(id: movie.id), animated: true)
                }
            }
        }
        
        let movies = modelManager.obtainCurrentMovies()
        for movie in movies {
            if movie.title == textField.text {
                self.present(DetailViewController(id: movie.id), animated: true)
            }
        }
        
        self.present(homeView.failedAlert, animated: true)
        return true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.size.height
  
        let progress = (offsetY + visibleHeight) / contentHeight
        
        if progress >= 0.85 && collectionViewDataSource?.selectedCity == nil {
            Task {
                let newMovies = await modelManager.obtainNewPageMovies()
                listMoviesCollectioViewDiffableDataSource?.updateSnapshot(movies: newMovies, animated: false)
                calculateCollectionViewHeight(itemsCount: modelManager.countMovies)
            }
        }
    }
}
