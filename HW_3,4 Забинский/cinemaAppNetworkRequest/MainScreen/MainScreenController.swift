//
//  ViewController.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 24.12.2024.
//

import UIKit

class MainScreenController: UIViewController {
    private var customView: MainScreenView {
        view as! MainScreenView
    }
    private let dataManager = MainScreenDataManager()
    private lazy var popularFilmsCollectionViewDataSource: CollectionViewDiffableDataSource = {
        CollectionViewDiffableDataSource()
    }()
    private lazy var popularFilmsCollectionViewDelegate: PopularFilmsDelegate = {
        PopularFilmsDelegate(delegate: self)
    }()
    private lazy var filmsCollectionViewDataSource: CollectionViewDiffableDataSource = {
        CollectionViewDiffableDataSource()
    }()
    private let customTitleView = NavigationItemView(title: "Что вы хотите посмотреть?")
    private var filmsCollectionViewDelegate: FilmsCollectionViewDelegate?
    private var selectedCity: City?
    private var cities: [City] = []
    private var originalFilms: [Film] = []
    private var downloadedFilms: [Film] = []
    private var anothetCititesFilms: [Film] = []
    private lazy var feedbackGenerator: UIImpactFeedbackGenerator = {
        UIImpactFeedbackGenerator(style: .heavy)
    }()
    
    override func loadView() {
        super.loadView()
        view = MainScreenView(cityCollectionViewDelegate: self, searchFilmDelegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewData()
        customView.setDelegateToMainScrollView(delegate: self)
        setupNavigationBar()
    }

    func setCollectionViewHeight() {
        var quantity: Int = originalFilms.count
        var spacing = 2 * Constants.ultraTiny
        if dataManager.currentPage != 1 {
            quantity = (selectedCity == nil) ? downloadedFilms.count
                                             : anothetCititesFilms.count
            spacing = CGFloat(((2 + dataManager.currentPage) * 2)) * Constants.ultraTiny
        }
        let numberOfRows = (quantity % 3 == 0) ? quantity / 3
                                               : quantity / 3 + 1
        /// Constants.screenWidth / 2.25 - filmCollectionView item height; Constants.ultraTiny / 2 - lineSpacing in CV
        let height = CGFloat(numberOfRows) * (Constants.screenWidth / 2.25 + Constants.ultraTiny)
        customView.setFilmsCollectionViewHeight(height: height + spacing)
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customTitleView)
    }
    
    private func setupCollectionViewData() {
        Task {
            async let citiesTask = dataManager.obtainCities()
            async let popularFilmsTask = dataManager.obtainPopularFilms()
            async let originalFilmsTask = dataManager.obtainFilms()
            
            cities = await citiesTask
            let popularFilms = await popularFilmsTask
            originalFilms = await originalFilmsTask
            downloadedFilms = originalFilms

            customView.setDataSourceForCityCollectionView(dataSourceForCityCollectionView: self)
            customView.setDelegateToPopularFilmsCollecitonView(popularFilmsCollectionViewDelegate: popularFilmsCollectionViewDelegate)
            popularFilmsCollectionViewDataSource.setupPopulafFilmsCollectionView(with: customView.getPopularFilmsCollectionView(), films: popularFilms, didLoadData: dataManager.didLoadData())
            
            filmsCollectionViewDataSource.setupFilmsCollectionView(with: customView.getFilmsCollectionView(), films: originalFilms)
            filmsCollectionViewDelegate = FilmsCollectionViewDelegate(didTapOnFilmDelegate: self)

            customView.setDelegateToFilmsCollecitonView(filmsCollectionViewDelegate: filmsCollectionViewDelegate!)
            dataManager.updateValueAfterSaving()
            setCollectionViewHeight()
        }
    }
}

extension MainScreenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        let city = cities[indexPath.item]
        let shouldBeHighlighter = (selectedCity == city)
        cell.setupWithCity(city, isHighlighted: shouldBeHighlighter)
        return cell
    }
}

extension MainScreenController: CityCollectionViewDelegate {
    func highlightCity(at index: Int) {
        feedbackGenerator.impactOccurred()
        let updatedCity = cities[index]
        
        if selectedCity == updatedCity {
            dataManager.backToDefaultPage()
            downloadedFilms = originalFilms
            selectedCity = nil
            filmsCollectionViewDataSource.applyDefaultFilmsSnapshot(with: originalFilms, shouldCreateSnapshot: true)
        } else {
            selectedCity = updatedCity
            Task {
                anothetCititesFilms = await dataManager.obtainFilmsInSelectedCity(updatedCity)
                filmsCollectionViewDataSource.applyDefaultFilmsSnapshot(with: anothetCititesFilms, shouldCreateSnapshot: true)
                setCollectionViewHeight()
            }
        }
    }
}

extension MainScreenController: DidTapOnFilmDelegate {
    func didTapOnFilm(withId id: Int) {
        Task {
            if let filmWithInfo = await dataManager.getDetailAboutFilm(id) {
                feedbackGenerator.impactOccurred()
                
                let filmDetailScreen = FilmDetailController(withFilm: filmWithInfo)
                let filmDetailScreenNavigationController = UINavigationController(rootViewController: filmDetailScreen)
                filmDetailScreenNavigationController.modalPresentationStyle = .custom
                filmDetailScreenNavigationController.transitioningDelegate = self
                filmDetailScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
                self.present(filmDetailScreenNavigationController, animated: true)
            }
        }
    }
}

extension MainScreenController: SearchFilmDelegate {
    func searchFilm(withTitle title: String) {
        /// If the user changed selectedCity, this means selectedCity != nil and we should search for the movie in anothetCititesFilms otherwise - in default films
        let searchedFilm = (selectedCity == nil) ? downloadedFilms.filter({ $0.title.lowercased() == title.lowercased() })
                                                 : anothetCititesFilms.filter({ $0.title.lowercased() == title.lowercased() })
        if !searchedFilm.isEmpty {
            Task {
                if let filmWithInfo = await dataManager.getDetailAboutFilm(searchedFilm[0].id) {
                    let filmDetailScreen = FilmDetailController(withFilm: filmWithInfo)
                    let filmDetailScreenNavigationController = UINavigationController(rootViewController: filmDetailScreen)
                    filmDetailScreenNavigationController.modalPresentationStyle = .custom
                    filmDetailScreenNavigationController.transitioningDelegate = self
                    filmDetailScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
                    self.present(filmDetailScreenNavigationController, animated: true)
                    
                    customView.clearSearchBar()
                }
            }
        } else {
            self.present(customView.getWrongTitleAlert(), animated: true)
        }
        customView.dismissKeyboard()
    }
}

extension MainScreenController: DidTapOnPopularFilmDelegate {
    func didTapOnFilm(film: Film) {
        Task {
            if let filmWithInfo = await dataManager.getDetailAboutFilm(film.id) {
                feedbackGenerator.impactOccurred()
                
                let filmDetailScreen = FilmDetailController(withFilm: filmWithInfo)
                let filmDetailScreenNavigationController = UINavigationController(rootViewController: filmDetailScreen)
                filmDetailScreenNavigationController.modalPresentationStyle = .custom
                filmDetailScreenNavigationController.transitioningDelegate = self
                filmDetailScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
                self.present(filmDetailScreenNavigationController, animated: true)
            }
        }
    }
}

extension MainScreenController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        TransitionAnimator(duration: 0.8, transitionMode: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        TransitionAnimator(duration: 0.8, transitionMode: .dismiss)
    }
}

extension MainScreenController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let threshold: CGFloat = customView.searchBar.bounds.height + CGFloat(Constants.tiny)

        if offsetY > threshold {
            if navigationItem.titleView == nil {
                customView.searchBar.removeFromSuperview()
                
                navigationItem.leftBarButtonItem = nil
                navigationItem.titleView = customView.searchBar
                customView.configureSearchBarStyle(customView.searchBar)
            }
        } else {
            if navigationItem.titleView != nil {
                navigationItem.titleView = nil
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customTitleView)
                customView.dataStackView.insertArrangedSubview(customView.searchBar, at: 0)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            
        if selectedCity == nil {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.size.height
            
            if offsetY + scrollViewHeight >= contentHeight * 0.75 {
                Task {
                    dataManager.updatePage()
                    let filmsOnNewPage = await dataManager.obtainFilms()
                    if !filmsOnNewPage.isEmpty {
                        downloadedFilms += filmsOnNewPage
                        filmsCollectionViewDataSource.applyDefaultFilmsSnapshot(with: filmsOnNewPage, shouldCreateSnapshot: false)
                        setCollectionViewHeight()
                    }
                }
            }
        }
    }
}
