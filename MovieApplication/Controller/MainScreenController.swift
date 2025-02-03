import UIKit

class MainScreenController: UIViewController {
    private var customView: MainScreenView {
        view as! MainScreenView
    }
    private let dataManager = MainScreenDataManager()
    private lazy var popularFilmsCollectionViewDataSource: CollectionViewDiffableDataSource = {
        CollectionViewDiffableDataSource()
    }()
    private lazy var popularFilmsCollectionViewDelegate: TopMoviesDelegate = {
        TopMoviesDelegate(delegate: self)
    }()
    private lazy var filmsCollectionViewDataSource: CollectionViewDiffableDataSource = {
        CollectionViewDiffableDataSource()
    }()
    private let customTitleView = NavigationItemView(title: "Что вы хотите посмотреть?")
    private var moviesCollectionViewDelegate: MovieCollectionViewDelegate?
    private var selectedCity: City?
    private var cities: [City] = []
    private var originalFilms: [Movie] = []
    private var downloadedFilms: [Movie] = []
    private var anothetCititesFilms: [Movie] = []
    private lazy var feedbackGenerator: UIImpactFeedbackGenerator = {
        UIImpactFeedbackGenerator(style: .heavy)
    }()
    
    override func loadView() {
        super.loadView()
        view = MainScreenView(cityCollectionViewDelegate: self)
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
        
        let height = CGFloat(numberOfRows) * (Constants.screenWidth / 2.25 + Constants.ultraTiny)
        customView.setMoviesCollectionViewHeight(height: height + spacing)
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customTitleView)
    }
    
    private func setupCollectionViewData() {
        Task {
            // Asynchronously fetch data for cities, popular films, and original film
            async let citiesTask = dataManager.obtainCities()
            async let topMoviesTask = dataManager.obtainTopMovies()
            async let originalFilmsTask = dataManager.obtainMovies()
            
            cities = await citiesTask
            let topMovies = await topMoviesTask
            originalFilms = await originalFilmsTask
            downloadedFilms = originalFilms

            customView.setDataSourceForCityCollectionView(dataSourceForCityCollectionView: self)
            customView.setDelegateToTopMoviesCollecitonView(popularFilmsCollectionViewDelegate: popularFilmsCollectionViewDelegate)
            popularFilmsCollectionViewDataSource.setupTopMoviesCollectionView(with: customView.getTopMoviesCollectionView(), movies: topMovies, didLoadData: dataManager.didLoadData())
            
            filmsCollectionViewDataSource.setupMoviesCollectionView(with: customView.getMovieCollectionView(), movies: originalFilms)
            moviesCollectionViewDelegate = MovieCollectionViewDelegate(tappedOnMovieDelegate: self)

            customView.setDelegateToMoviesCollecitonView(movieCollectionViewDelegate: moviesCollectionViewDelegate!)
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
        // Handle the case when the selected city is tapped again (reset to default)
        if selectedCity == updatedCity {
            dataManager.backToDefaultPage()
            downloadedFilms = originalFilms
            selectedCity = nil
            filmsCollectionViewDataSource.applyDefaultMoviesSnapshot(with: originalFilms, shouldCreateSnapshot: true)
        } else {
            selectedCity = updatedCity
            // Fetch films for the selected city
            Task {
                anothetCititesFilms = await dataManager.obtainMoviesInSelectedCity(updatedCity)
                filmsCollectionViewDataSource.applyDefaultMoviesSnapshot(with: anothetCititesFilms, shouldCreateSnapshot: true)
                setCollectionViewHeight()
            }
        }
    }
}

extension MainScreenController: TappedOnMovieDelegate {
    func tappedOnMovie(withId id: Int) {
        Task {
            if let filmWithInfo = await dataManager.getDetailAboutMovie(id) {
                feedbackGenerator.impactOccurred()
                
                let filmDetailScreen = MovieDetailController(withFilm: filmWithInfo)
                let filmDetailScreenNavigationController = UINavigationController(rootViewController: filmDetailScreen)
                filmDetailScreenNavigationController.modalPresentationStyle = .custom
                filmDetailScreenNavigationController.transitioningDelegate = self
                filmDetailScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
                self.present(filmDetailScreenNavigationController, animated: true)
            }
        }
    }
}

extension MainScreenController: TappedOnTopMovieDelegate {
    // Fetch movie details asynchronously
    func tappedOnMovie(movie movie: Movie) {
        Task {
            if let movieWithInfo = await dataManager.getDetailAboutMovie(movie.id) {
                feedbackGenerator.impactOccurred()
                
                let movieDetailScreen = MovieDetailController(withFilm: movieWithInfo)
                let movieDetailScreenNavigationController = UINavigationController(rootViewController: movieDetailScreen)
                movieDetailScreenNavigationController.modalPresentationStyle = .custom
                movieDetailScreenNavigationController.transitioningDelegate = self
                movieDetailScreenNavigationController.navigationBar.barTintColor = Colors.mainGray
                self.present(movieDetailScreenNavigationController, animated: true)
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
                    let filmsOnNewPage = await dataManager.obtainMovies()
                    if !filmsOnNewPage.isEmpty {
                        downloadedFilms += filmsOnNewPage
                        filmsCollectionViewDataSource.applyDefaultMoviesSnapshot(with: filmsOnNewPage, shouldCreateSnapshot: false)
                        setCollectionViewHeight()
                    }
                }
            }
        }
    }
}

