//
//  ViewController.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 15.01.2025.
//

import Foundation
import UIKit
import CoreData

final class ViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Что хотите посмотреть?"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск фильмов..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(white: 1, alpha: 0.15)
            textField.layer.cornerRadius = 7
            textField.layer.masksToBounds = true
            textField.textColor = .white
            textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)

            if let glassIconView = textField.leftView as? UIImageView {
                glassIconView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = .lightGray
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 16)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Поиск фильмов...", attributes: attributes)
        }

        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 250)
        layout.minimumLineSpacing = 30
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collection.backgroundColor = .lightBlack
        return collection
    }()
    
    private lazy var citiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите город:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var citiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collection.backgroundColor = .lightBlack
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var networkManager = NetworkManager.shared
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Film> = {
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlack
        setupUI()
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        loadData()

        Task {
            await fetchFilmsFromAPI()
            await fetchRandomFilms()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
        Task {
            do {
                let fetchedCities = try await networkManager.obtainCities()
                DispatchQueue.main.async {
                    self.citiesFromAPI = fetchedCities
                    self.citiesCollectionView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Failed to load cities.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        
        searchResultsTableView.isHidden = true
        if let tabBar = self.tabBarController?.tabBar {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .lightBlack
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }

    private var randomMovies: [Film] = []
    
    func fetchRandomFilms() async {
        do {
            let randomFilms = try await networkManager.obtainRandomFilms()
            DispatchQueue.main.async {
                if !randomFilms.isEmpty {
                    self.randomMovies = randomFilms
                    self.collectionView.reloadData()
                } else {
                    self.randomMovies = self.fetchedResultsController.fetchedObjects ?? []
                    self.collectionView.reloadData()
                }
            }
        } catch {
            print("Ошибка загрузки топ-10 фильмов: \(error)")
        }
    }
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(collectionView)
        contentView.addSubview(citiesLabel)
        contentView.addSubview(citiesCollectionView)
        contentView.addSubview(searchResultsTableView)
        contentView.addSubview(cityMoviesCollectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            searchBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -15),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            
            citiesLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            citiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            citiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            citiesCollectionView.topAnchor.constraint(equalTo: citiesLabel.bottomAnchor, constant: 8),
            citiesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            citiesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            citiesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            searchResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchResultsTableView.heightAnchor.constraint(equalToConstant: 200),
            
            cityMoviesCollectionView.topAnchor.constraint(equalTo: citiesCollectionView.bottomAnchor, constant: 16),
            cityMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cityMoviesCollectionView.heightAnchor.constraint(equalToConstant: 500),
            
            cityMoviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func loadData() {
        do {
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.isEmpty == true {
                Task {
                    await fetchFilmsFromAPI()
                }
            }
            collectionView.reloadData()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    
    func fetchFilmsFromAPI() async {
        do {
            try await networkManager.obtainFilms(page: 1)
            DispatchQueue.main.async {
                self.loadData()
            }
        } catch {
            print("Failed to fetch films: \(error)")
        }
    }
    
    private var searchResults: [Film] = []
    private lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.backgroundColor = .lightBlack
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    private var citiesFromAPI: [City] = []

    private var cityMovies: [Film] = []

    private lazy var cityMoviesCollectionView: UICollectionView = {
        let padding: CGFloat = 16
        let interItemSpacing: CGFloat = 8
        let availableWidth = UIScreen.main.bounds.width - padding * 2 - interItemSpacing * 2
        let itemWidth = availableWidth / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = interItemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightBlack
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "CityMovieCell")
        return collectionView
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            let totalMovies = randomMovies.isEmpty ? fetchedResultsController.fetchedObjects?.count ?? 0 : randomMovies.count
            return min(totalMovies, 10)
        } else if collectionView == self.citiesCollectionView {
            return citiesFromAPI.count
        } else if collectionView == self.cityMoviesCollectionView {
            return cityMovies.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Не удалось создать ячейку с идентификатором \(MovieCollectionViewCell.identifier)")
            }
            let movie: Film
            var rank: Int? = nil
            
            if randomMovies.isEmpty {
                if let fetchedObjects = fetchedResultsController.fetchedObjects, indexPath.item < fetchedObjects.count {
                    movie = fetchedResultsController.object(at: indexPath)
                    rank = indexPath.item + 1
                } else {
                    fatalError("Неверный индекс в fetchedResultsController")
                }
            } else {
                if indexPath.item < randomMovies.count {
                    movie = randomMovies[indexPath.item]
                    rank = indexPath.item + 1
                } else {
                    fatalError("Неверный индекс в randomMovies")
                }
            }
            
            cell.configure(with: movie, rank: rank)
            cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
            return cell
            
        } else if collectionView == self.citiesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as? CityCollectionViewCell else {
                fatalError("Не удалось создать ячейку с идентификатором \(CityCollectionViewCell.identifier)")
            }
            let city = citiesFromAPI[indexPath.row]
            cell.configure(with: city.name ?? "Unknown")
            cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
            return cell
            
        } else if collectionView == self.cityMoviesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityMovieCell", for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Не удалось создать ячейку с идентификатором 'CityMovieCell'")
            }
            let movie = cityMovies[indexPath.row]
            cell.configure(with: movie, rank: nil)
            cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.animateSelection {
                if collectionView == self.citiesCollectionView {
                    let selectedCity = self.citiesFromAPI[indexPath.row]
                    let citySlug = selectedCity.slug ?? (selectedCity.name?.lowercased() ?? "")
                    DispatchQueue.main.async {
                        self.activityIndicator.startAnimating()
                    }
                    Task {
                        do {
                            let filmsResponse = try await self.networkManager.obtainFilmForCities(for: citySlug)
                            if let filmsArray = filmsResponse.results?.allObjects as? [Film], !filmsArray.isEmpty {
                                DispatchQueue.main.async {
                                    self.cityMovies = filmsArray
                                    self.cityMoviesCollectionView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                    let alert = UIAlertController(title: "Информация",
                                                                  message: "Для выбранного города нет доступных фильмов.",
                                                                  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(alert, animated: true)
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                let alert = UIAlertController(title: "Ошибка",
                                                              message: "Не удалось загрузить фильмы для \(selectedCity.name ?? "выбранного города").",
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                } else if collectionView == self.collectionView {
                    guard indexPath.row < self.randomMovies.count else {
                        return
                    }
                    let selectedFilm = self.randomMovies[indexPath.row]
                    let detailVC = DetailViewController()
                    detailVC.film = selectedFilm
                    self.pushDetailViewController(detailVC)
                } else if collectionView == self.cityMoviesCollectionView {
                    guard indexPath.row < self.cityMovies.count else { return }
                    let selectedFilm = self.cityMovies[indexPath.row]
                    let detailVC = DetailViewController()
                    detailVC.film = selectedFilm
                    self.pushDetailViewController(detailVC)
                }
            }
        }
    }
    func pushDetailViewController(_ detailVC: DetailViewController) {
        guard let containerView = self.navigationController?.view else { return }
        
        detailVC.loadViewIfNeeded()
        
        detailVC.view.frame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        detailVC.view.setNeedsLayout()
        detailVC.view.layoutIfNeeded()
        
        detailVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        detailVC.view.alpha = 0
        
        containerView.addSubview(detailVC.view)
        containerView.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            detailVC.view.transform = .identity
            detailVC.view.alpha = 1
        }
        
        animator.addCompletion { _ in
            self.navigationController?.pushViewController(detailVC, animated: false)
            detailVC.view.removeFromSuperview()
        }
        
        animator.startAnimation()
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            searchResults = []
            searchResultsTableView.isHidden = true
            return
        }

        var combinedMovies = [Film]()
        
        combinedMovies.append(contentsOf: randomMovies)
        combinedMovies.append(contentsOf: cityMovies)
        
        let uniqueObjectIDs = Set(combinedMovies.map { $0.objectID })
        
        let uniqueMovies = uniqueObjectIDs.compactMap { id in
            CoreDataManager.shared.viewContext.object(with: id) as? Film
        }
        
        let filtered = uniqueMovies.filter {
            ($0.title ?? "").localizedCaseInsensitiveContains(searchText)
        }
        
        searchResults = filtered
        
        searchResultsTableView.reloadData()
        searchResultsTableView.isHidden = searchResults.isEmpty
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchResults.isEmpty {
            let alert = UIAlertController(
                title: "Not Found",
                message: "Film with title \"\(searchBar.text ?? "")\" not found.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard indexPath.row < searchResults.count else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let film = searchResults[indexPath.row]
        cell.textLabel?.text = film.title
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .lightBlack
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = searchResults[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.film = selectedFilm
        navigationController?.pushViewController(detailVC, animated: true)
        
        searchResults = []
        searchResultsTableView.reloadData()
        searchResultsTableView.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
extension UICollectionViewCell {
    func animateSelection(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            }, completion: { _ in
                completion()
            })
        })
    }
}
extension UIColor {
    static let lightBlack = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
}

