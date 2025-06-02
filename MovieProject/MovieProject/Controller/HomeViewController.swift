import UIKit

class HomeViewController: UIViewController {
    private let page = 1
    private lazy var mainView = HomeView(frame: .zero)
    private var dataManager = DataManager()
    private var dataSourceTopMovies = TopMoviesCollectionDataSource(movies: [])
    private var dataSourceCities = CityCollectionViewDataSource(dataSource: [])
    private var dataSourceMovies = AllMoviesCollectionViewDataSource(dataSource: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopMovies()
        fetchCities(page: page)
        fetchMovies(page: page)
        setupNavigationController()
        setupSearchBarDelegate()
    }
    
    override func loadView() {
        view = mainView
    }
    
    private func setupNavigationController() {
        self.navigationItem.backButtonTitle = "Вернуться"
    }
    
    private func fetchMovies(page: Int) {
        Task {
            let movies = await dataManager.obtainAndCheckMovies(page: page)
            dataSourceMovies = AllMoviesCollectionViewDataSource(dataSource: movies)
            dataSourceMovies.onMoviesDetail = { [weak self] movieId in
                self?.getDetailMovieScreenById(movieId)
            }
            mainView.setupMoviesDataSourceCollectionView(self.dataSourceMovies)
            mainView.allMoviesCollectionView.delegate = self.dataSourceMovies
            mainView.allMoviesCollectionView.reloadData()
            
        }
    }
    
    private func fetchTopMovies() {
        Task {
            let movies = await dataManager.getRandomMovies(page: page)
            dataSourceTopMovies = TopMoviesCollectionDataSource(movies: movies)
            dataSourceTopMovies.onMoviesDetail = { [weak self] movieId in
                self?.getDetailMovieScreenById(movieId)
            }
            
            mainView.setupTopMoviesDataSourceCollectionView(self.dataSourceTopMovies)
            mainView.topMoviesCollectionView.delegate = self.dataSourceTopMovies
            mainView.topMoviesCollectionView.reloadData()
        }
    }
    
    private func fetchCities(page: Int) {
        Task {
            let cities = await dataManager.getCities()
            dataSourceCities = CityCollectionViewDataSource(dataSource: cities)
            dataSourceCities.onClickCityCell = { [weak self] city in
                self?.fetchMoviesByCitySlug(forCitySlug: city, page: page)
                }
            
            mainView.setupCityDataSourceCollectionView(self.dataSourceCities)
            mainView.setupCityDelegate(self.dataSourceCities)
            mainView.cityCollectionView.reloadData()
        }
    }
    
    private func fetchMoviesByCitySlug(forCitySlug citySlug: String, page: Int) {
            Task {
                guard let movies = await dataManager.obtainMoviesByCity(citySlug: citySlug, page: 1) else { return showAlertNoFetchMoviesByCity(city: citySlug) }
                dataSourceMovies.onMoviesDetail = { [weak self] movieId in
                    self?.getDetailMovieScreenById(movieId)
            }
                
            dataSourceMovies.updateDataSource(with: movies)
            mainView.allMoviesCollectionView.delegate = self.dataSourceMovies
            mainView.allMoviesCollectionView.reloadData()
        }
    }
    
    private func getDetailMovieScreenById(_ movieId: Int64) {
        Task {
            guard let movieDetail = await dataManager.getDetailMovie(Int(movieId)) else {
                return showAlertNoInternetConnection() }
            
            let detailVc = DetailMovieViewController(movieDetail: movieDetail)
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
  
    func showAlertNoInternetConnection() {
        let alert = UIAlertController(title: "Ошибка", message: "Кажется у вас отсуствует интернет подключения, включите интернет и попробуйте снова", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func showAlertNoFetchMoviesByCity(city: String) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось найти фильмы в городе \(city)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func showAlertMovieNotFound() {
        let alert = UIAlertController(title: "Ошибка", message: "Фильм с таким названием не найдем", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func setupSearchBarDelegate() {
        mainView.setupSearchBarDelegate(self)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else { return }

        if let movie = dataManager.getMovieByTitle(text) {
            getDetailMovieScreenById(movie.id)
            mainView.searchBar.text = ""
        } else {
            showAlertMovieNotFound()
        }
    }
}
