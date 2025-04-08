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
    private var popularFilmsCollectionViewDataSource: CollectionViewDiffableDataSource = CollectionViewDiffableDataSource()
    private var filmsCollectionViewDataSource: CollectionViewDiffableDataSource = CollectionViewDiffableDataSource()
    private var filmsCollectionViewDelegate: FilmsCollectionViewDelegate?
    private var selectedCity: City?
    private var cities: [City] = []
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let customTitleView = NavigationItemView(title: "Что вы хотите посмотреть?")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customTitleView)
    }
    
    private func setupCollectionViewData() {
        Task {
            async let citiesTask = dataManager.obtainCities()
            async let popularFilmsTask = dataManager.obtainPopularFilms()
            async let downloadedFilmsTask = dataManager.obtainFilms()
            
            cities = await citiesTask
            let popularFilms = await popularFilmsTask
            downloadedFilms = await downloadedFilmsTask
            
            customView.setDataSourceForCityCollectionView(dataSourceForCityCollectionView: self)
            
            popularFilmsCollectionViewDataSource.setupPopulafFilmsCollectionView(with: customView.getPopularFilmsCollectionView(), films: popularFilms, didLoadData: dataManager.didLoadData())
            
            filmsCollectionViewDataSource.setupFilmsCollectionView(with: customView.getFilmsCollectionView(), films: downloadedFilms)
            filmsCollectionViewDelegate = FilmsCollectionViewDelegate(dataSource: filmsCollectionViewDataSource, didTapOnFilmDelegate: self)

            customView.setDelegateToFilmsCollecitonView(filmsCollectionViewDelegate: filmsCollectionViewDelegate!)
            dataManager.updateValueAfterSaving()
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
            selectedCity = nil
            filmsCollectionViewDataSource.applyDefaultFilmsSnapshot(with: downloadedFilms)
        } else {
            selectedCity = updatedCity
            Task {
                anothetCititesFilms = await dataManager.obtainFilmsInSelectedCity(updatedCity)
                filmsCollectionViewDataSource.applyDefaultFilmsSnapshot(with: anothetCititesFilms)
            }
        }
    }
}

extension MainScreenController: DidTapOnFilmDelegate {
    func didTapOnFilm(withId id: Int) {
        feedbackGenerator.impactOccurred()
        Task {
            if let filmWithInfo = await dataManager.getDetailAboutFilm(id) {
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
        let searchedFilm = (selectedCity == nil) ? downloadedFilms.filter({ $0.title == title })
                                                 : anothetCititesFilms.filter({ $0.title == title })
        if !searchedFilm.isEmpty {
            Task {
                if let filmWithInfo = await dataManager.getDetailAboutFilm(searchedFilm[0].id) {
                    let filmDetailScreen = FilmDetailController(withFilm: filmWithInfo)
                    let filmDetailScreenNavigationController = UINavigationController(rootViewController: filmDetailScreen)
                    filmDetailScreenNavigationController.modalPresentationStyle = .custom
                    filmDetailScreenNavigationController.transitioningDelegate = self
                    filmDetailScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
                    self.present(filmDetailScreenNavigationController, animated: true)
                }
            }
        } else {
            self.present(customView.getWrongTitleAlert(), animated: true)
        }
        customView.dismissKeyboard()
    }
}

extension MainScreenController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        TransitionAnimator(duration: 1.2, transitionMode: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        TransitionAnimator(duration: 1.2, transitionMode: .dismiss)
    }
}
