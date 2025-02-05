import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    var selectedCity: String?
    private var moviesCollectionViewHeightConstraint: NSLayoutConstraint!
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private let searchBar = UISearchBar()
    private let topMoviesCollectionView: UICollectionView
    private let citiesCollectionView: UICollectionView
    private let moviesCollectionView: UICollectionView
    
    private var movies: [Movie] = []
    private var topMovies: [Movie] = []
    private var cities: [City] = []
    //private var selectedCity: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let topLayout = UICollectionViewFlowLayout()
        topLayout.scrollDirection = .horizontal
        topLayout.itemSize = CGSize(width: 130, height: 210)
        topLayout.minimumLineSpacing = 20
        
        topMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: topLayout)
        
        let citiesLayout = UICollectionViewFlowLayout()
        citiesLayout.scrollDirection = .horizontal
        citiesLayout.itemSize = CGSize(width: 100, height: 40)
        citiesLayout.minimumLineSpacing = 10
        
        citiesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: citiesLayout)
        
        let gridLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2
        let cellWidth = (UIScreen.main.bounds.width - 40 - totalSpacing) / 3
        gridLayout.itemSize = CGSize(width: cellWidth, height: 180)
        gridLayout.minimumInteritemSpacing = spacing
        gridLayout.minimumLineSpacing = spacing
        
        moviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        moviesCollectionView.isScrollEnabled = false
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        fetchMovies()
        fetchCities()
    }
    private func fetchMovies() {
            guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/") else { return }
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                let decodedMovies = try? JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    self.movies = decodedMovies?.results ?? []
                    self.topMovies = self.movies.shuffled().prefix(10).map { $0 }
                    self.updateMoviesGridHeight()
                    self.topMoviesCollectionView.reloadData()
                    self.moviesCollectionView.reloadData()
                }
            }.resume()
        }
    private func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.alignment = .fill
        
        let titleLabel = UILabel()
        titleLabel.text = "Что вы хотите посмотреть?"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal // Убираем фон
        searchBar.backgroundColor = .clear  // Делаем фон прозрачным
        searchBar.barTintColor = .white     // Цвет текста и иконки
        searchBar.tintColor = .white        // Цвет курсора
        searchBar.layer.cornerRadius = 10   // Закругляем углы
        searchBar.clipsToBounds = true      // Обрезаем фон
        searchBar.placeholder = "Поиск фильмов..."
        
        topMoviesCollectionView.delegate = self
        topMoviesCollectionView.dataSource = self
        topMoviesCollectionView.backgroundColor = .black
        topMoviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        citiesCollectionView.delegate = self
        citiesCollectionView.dataSource = self
        citiesCollectionView.backgroundColor = .black
        citiesCollectionView.register(CityCell.self, forCellWithReuseIdentifier: "CityCell")
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.backgroundColor = .black
        moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, searchBar, topMoviesCollectionView, citiesCollectionView, moviesCollectionView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        topMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        citiesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            topMoviesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            citiesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
        moviesCollectionViewHeightConstraint = moviesCollectionView.heightAnchor.constraint(equalToConstant: 600)
        moviesCollectionViewHeightConstraint.isActive = true
    }
    
    private func fetchMovies(for city: String?) {
        var urlString = "https://kudago.com/public-api/v1.4/movies/"
        if let city = city {
            urlString += "?location=\(city)"
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            let decodedMovies = try? JSONDecoder().decode(MovieResponse.self, from: data)
            DispatchQueue.main.async {
                self.movies = decodedMovies?.results ?? []
                self.updateMoviesGridHeight()
                self.moviesCollectionView.reloadData()
            }
        }.resume()
    }
    
    private func fetchCities() {
        guard let url = URL(string: "https://kudago.com/public-api/v1.2/locations/?lang=ru") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            let decodedCities = try? JSONDecoder().decode([City].self, from: data)
            DispatchQueue.main.async {
                self.cities = decodedCities ?? []
                self.citiesCollectionView.reloadData()
            }
        }.resume()
    }
    
    private func updateMoviesGridHeight() {
        let rows = ceil(Double(movies.count) / 3.0)
        let newHeight = rows * 190 + ((rows - 1) * 10)
        moviesCollectionViewHeightConstraint.constant = CGFloat(newHeight)
        view.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topMoviesCollectionView {
            return topMovies.count
        } else if collectionView == citiesCollectionView {
            return cities.count
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topMoviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = topMovies[indexPath.item]
            cell.configure(with: movie)
            return cell
        } else if collectionView == citiesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCell
            let city = cities[indexPath.item]
            cell.configure(with: city)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = movies[indexPath.item]
            cell.configure(with: movie)
            return cell
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == citiesCollectionView {
                let city = cities[indexPath.item]
                selectedCity = city.slug
                fetchMovies(for: selectedCity)
            } else if collectionView == moviesCollectionView {
                let movie = movies[indexPath.item] // Получаем выбранный фильм
                let detailVC = DetailViewController(movieId: movie.id) // Передаем ID фильма
                navigationController?.pushViewController(detailVC, animated: true)
            }
        else if collectionView == topMoviesCollectionView {
            let movie = topMovies[indexPath.item] // Получаем выбранный фильм
            let detailVC = DetailViewController(movieId: movie.id) // Передаем ID фильма
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

class CityCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center

        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        contentView.layer.cornerRadius = 10

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    

    func configure(with city: City) {
        titleLabel.text = city.name
    }
}
