//
//  WatchlistViewController.swift
//  films
//
//  Created by Кирилл Титов on 15.01.2025.
//

import UIKit

class WatchlistViewController: UIViewController {
        
    private let watchlistManager = WatchlistManager.shared
    private var watchlistMovies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let itemWidth = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: itemWidth, height: 150)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 10, bottom: spacing, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "back")
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ошибка загрузки списка избранного."
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "back")
        title = "Избранное"
        
        setupCollectionView()
        setupUI()
        setupConstraints()
        fetchWatchlistMovies()
        setupNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(watchlistUpdated), name: .watchlistUpdated, object: nil)
    }
    
    
    @objc private func watchlistUpdated() {
        fetchWatchlistMovies()
    }
    
    
    private func fetchWatchlistMovies() {
        showLoading(true)
        let movieIDs = watchlistManager.getAllWatchlistMovies()
        var validMovieIDs: [Int] = []
        
        guard !movieIDs.isEmpty else {
            DispatchQueue.main.async {
                self.showLoading(false)
                self.errorLabel.text = "Список избранного пуст."
                self.errorLabel.isHidden = false
            }
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var fetchedMovies: [Movie] = []
        
        for id in movieIDs {
            dispatchGroup.enter()
            fetchMovieDetails(movieID: id) { movie, error in
                if let movie = movie {
                    fetchedMovies.append(movie)
                    validMovieIDs.append(id)
                } else {
                    print("Movie ID \(id) is invalid or missing.")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.showLoading(false)
            WatchlistManager.shared.updateWatchlist(validMovieIDs)
            
            if fetchedMovies.isEmpty {
                self.errorLabel.text = "Ошибка загрузки избранного. Проверьте подключение к интернету или попробуйте позже."
                self.errorLabel.isHidden = false
            } else {
                self.watchlistMovies = fetchedMovies
                self.collectionView.reloadData()
                self.errorLabel.isHidden = true
            }
        }
    }

    private func showLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            collectionView.isHidden = true
            errorLabel.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
        }
    }
    
    private func fetchMovieDetails(movieID: Int, completion: @escaping (Movie?, Error?) -> Void) {
        let urlString = "https://kudago.com/public-api/v1.4/movies/\(movieID)/"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching movie details for ID \(movieID): \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data received for movie ID \(movieID)")
                completion(nil, NSError(domain: "No Data", code: 404, userInfo: nil))
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(movie, nil)
            } catch {
                print("Error decoding movie details for ID \(movieID): \(error)")
                completion(nil, error)
            }
        }.resume()
    }

        
    private func configureNavigationBarAppearance() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "back")
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        appearance.buttonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -1000, vertical: 0)
        appearance.buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        
        navigationBar.tintColor = .white
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension WatchlistViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return watchlistMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to dequeue MovieCollectionViewCell")
        }
        
        let movie = watchlistMovies[indexPath.item]
        cell.configure(with: movie)
        cell.onRemove = { [weak self] in
            self?.removeFromWatchlist(movie: movie)
        }
        
        return cell
    }
    
    private func removeFromWatchlist(movie: Movie) {
        watchlistManager.removeFromWatchlist(movieID: movie.id)
        // Обновление списка
        fetchWatchlistMovies()
    }
}


extension WatchlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = watchlistMovies[indexPath.item]
        let detailVC = MovieDetailViewController()
        detailVC.movie = selectedMovie
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension Notification.Name {
    static let watchlistUpdated = Notification.Name("watchlistUpdated")
}
