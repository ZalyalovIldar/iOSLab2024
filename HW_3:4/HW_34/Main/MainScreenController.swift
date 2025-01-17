//
//  ViewController.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

class MainScreenController: UIViewController {
    private var mainScreenView: MainScreenView {
        view as! MainScreenView
    }
    private var prevCity: City?
    private var selectedCity: City? {
        didSet {
            if prevCity == selectedCity {
                prevCity = nil
                selectedCity = nil
    
                filmsDataSource?.applySnapshot(with: filmsOnFirstPage)
                loadedOnAnotherPageFilms = []
                filmsInCity = []
                mainScreenView.showShowMoreFilmsButton()
                currentPage = 2
            } else {
                Task {
                    filmsInCity = await dataManager.obtainFilmsInSelectedCity(city: selectedCity!)
                    filmsDataSource?.applySnapshot(with: filmsInCity)
                }
                mainScreenView.hideShowMoreFilmsButton()
            }
        }
    }
    private let dataManager = MainScreenDataManager()
    private var popularFilmsDataSource: TrendFilmsDiffableDataSource?
    private var filmsDataSource: FilmsDiffableDataSource?
    private var filmCollectionViewDelegate: FilmsCollectionViewDelegate?
    
    private var filmsOnFirstPage: [Film] = [] // обычные 20
    private var popularFilms: [Film] = [] // 10 сверху
    private var filmsInCity: [Film] = [] // фильмы в др городе
    private var loadedOnAnotherPageFilms: [Film] = [] // нижние по 20
    private lazy var cities: [City] = [] // города
    private var currentPage: Int = 2
    
    override func loadView() {
        super.loadView()
        view = MainScreenView(cityDelegate: self, movieSearchDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShowMoreFilmsButtonAction()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupData() {
        setupCities()
        loadData()
        setupCities()
        setupFilmsCollecitonView()
        setupTapOnTrendFilmsDelegate()
    }
    
    private func setupNavigationBar() {
        let view = CustomTitle()
        view.setupWithTitle(title: "Что вы хотите посмотреть?")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
        
        let hideButton = UIButton()
        hideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        hideButton.tintColor = .white
        hideButton.addAction(UIAction { _ in
            self.mainScreenView.endEditing(true)
        }, for: .touchUpInside)
        let hideKeyBoardButton = UIBarButtonItem(customView: hideButton)
        navigationItem.rightBarButtonItem = hideKeyBoardButton
    }
    
    private func loadData() {
        popularFilmsDataSource = TrendFilmsDiffableDataSource()
        let didLoadData = dataManager.didLoadData()
        
        if didLoadData {
            popularFilms = dataManager.obtainCoreDataFilms()

            popularFilmsDataSource?.setupPopulafFilmsCollectionView(with: mainScreenView.getTrendingMoviesCollectionView(), films: popularFilms, didLoadData: didLoadData)
        } else {
            Task {
                let filteredFilms = await Array(dataManager.obtainFilms().prefix(10)).sorted { $1.title > $0.title }
                popularFilms = filteredFilms
                popularFilmsDataSource?.setupPopulafFilmsCollectionView(with: mainScreenView.getTrendingMoviesCollectionView(), films: filteredFilms, didLoadData: didLoadData)
                dataManager.saveFilms(films: filteredFilms)
            }
        }
    }
    
    private func setupCities() {
        Task {
            cities = await dataManager.obtainCities()
            mainScreenView.setCityListDataSource(dataSource: self)
        }
    }
    
    private func setupFilmsCollecitonView() {
        filmsDataSource = FilmsDiffableDataSource()
        Task {
            filmsOnFirstPage = await dataManager.obtainFilms()
            filmsDataSource?.setupFilmsCollectionView(with: mainScreenView.getMoviesCollectionView(), films: filmsOnFirstPage)
            
            filmCollectionViewDelegate = FilmsCollectionViewDelegate(dataSource: filmsDataSource!, didTapOnFilmDelegate: self)
            mainScreenView.setMoviesDelegate(delegate: filmCollectionViewDelegate!)
        }
    }
    
    private func setShowMoreFilmsButtonAction() {
        mainScreenView.setActionToShowMoreFilmsButton(action: UIAction { _ in
            Task { [weak self] in
                guard let self else { return }
                let loadedRightNow = await dataManager.obtainFilmsOnPage(page: currentPage)
                loadedOnAnotherPageFilms += loadedRightNow
                currentPage += 1
                filmsDataSource?.applySnapshotWithoutCreating(with: loadedRightNow)
            }
        })
    }
    
    private func setupTapOnTrendFilmsDelegate() {
        mainScreenView.trendingMoviesCollection.delegate = self
    }
}

extension MainScreenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell,
            currentCity = cities[indexPath.row],
            isHighlighted = selectedCity == currentCity
        cell.setupWithCity(currentCity, isHighlighted: isHighlighted)
        return cell
    }
}

extension MainScreenController: CitySelectionDelegate, DidTapOnFilmDelegate, MovieSearchDelegate, UICollectionViewDelegate {
    func selectCity(at index: Int) {
        prevCity = selectedCity
        selectedCity = cities[index]
    }
    
    func didTapOnFilm(withId id: Int) {
        Task {
            if let filmDetail = await dataManager.getDetailAboutFilm(id: id) {
                let filmDetailScreen = FilmDetailController(withFilm: filmDetail)
                filmDetailScreen.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(filmDetailScreen, animated: true)
            }
        }
    }
    
    func findMovie(withTitle name: String) {
        var filmsToSearch: [Film] = popularFilms
        if selectedCity == nil {
            filmsToSearch += filmsOnFirstPage
            filmsToSearch += loadedOnAnotherPageFilms
        } else {
            filmsToSearch += filmsInCity
        }
        let searchedFilm = filmsToSearch.filter({ $0.title == name })
        if let searchedFilmId = searchedFilm.first?.id {
            Task {
                if let filmDetail = await dataManager.getDetailAboutFilm(id: searchedFilmId) {
                    let filmDetailScreen = FilmDetailController(withFilm: filmDetail)
                    filmDetailScreen.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(filmDetailScreen, animated: true)
                }
            }
        } else {
            self.present(mainScreenView.getMovieNotFoundAlert(), animated: true)
        }
        mainScreenView.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(CGAffineTransformMakeRotation(.pi / 12))
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                cell?.transform = .identity
            } completion: { _ in
                self.popularFilms.forEach {
                    print($0.title)
                }
                let filmId = self.popularFilms[indexPath.item].id
                Task {
                    if let filmDetail = await self.dataManager.getDetailAboutFilm(id: filmId) {
                        let filmDetailScreen = FilmDetailController(withFilm: filmDetail)
                        filmDetailScreen.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(filmDetailScreen, animated: true)
                    }
                }
            }
        }
    }
}

