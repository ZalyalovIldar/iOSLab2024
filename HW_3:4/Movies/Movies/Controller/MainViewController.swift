//
//  ViewController.swift
//  Movies
//
//  Created by Павел Калинин on 19.12.2024.
//

import UIKit

class MainViewController: UIViewController {
    let mainView = MainView()
    private let dataManager = DataManager.shared
    private let topListDataSource: TopListDataSource = TopListDataSource(movies: [])
    private let allMoviesDataSource = AllMoviesDataSource(allMovies: [])
    
    private var error: String? {
        didSet {
            if let error = error {
                mainView.showErrorLabel(with: error)
            } else {
                mainView.hideErrorLabel()
            }
        }
    }
        
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что хотите посмотреть?"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadData()
        setupSegmentControlAction()
        
        mainView.topCollectionView.delegate = self
        mainView.topCollectionView.dataSource = topListDataSource
        
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = allMoviesDataSource
        
        mainView.nextButtonDelegate = self
        mainView.searchIconDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }

    override func loadView() {
        view = mainView
    }
    
    private func setupSegmentControlAction() {
        mainView.customSegmentedControl.onSegmentSelected = {[weak self] city in
            guard let self = self else { return }
            Task {
                do {
                    self.mainView.startUpdatingAllMovies()
                    let allMovies = try await self.dataManager.obtainInitialAllMovies(in: self.mainView.customSegmentedControl.getCurrentValue())
                    //Обновление коллекции при смене города
                    self.mainView.listCollectionView.performBatchUpdates({
                        let itemCount = self.allMoviesDataSource.getItems().count
                        let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: 0) }
                        self.allMoviesDataSource.removeAll()
                        self.mainView.listCollectionView.deleteItems(at: indexPaths)
                        
                        // После удаления добавляем новые элементы
                        self.allMoviesDataSource.updateDataSource(with: allMovies)
                        let newIndexPaths = (0..<self.allMoviesDataSource.getItems().count).map { IndexPath(item: $0, section: 0) }
                        self.mainView.listCollectionView.insertItems(at: newIndexPaths)
                    }, completion: { isFinished in
                        self.mainView.finishUpdatingAllMovies()
                    })
                } catch {
                    self.mainView.finishUpdatingAllMovies()
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    private func loadData() {
        Task {
            do {
                CoreDataManager.shared.deleteAllMoviesEntity()
                let movies = try await dataManager.obtainAndSaveTopMovies()
                self.topListDataSource.updateMovies(movies)
                let cities = try await dataManager.obtainCities()
                mainView.customSegmentedControl.updateDataSource(with: cities)
                let allMovies = try await dataManager.getInitialMovies(in: mainView.customSegmentedControl.getCurrentValue())
                allMoviesDataSource.updateDataSource(with: allMovies)
                
                mainView.stopLoadingPageAnimation()
                mainView.reloadCityCollectionView()
                mainView.reloadTopCollectionView()
                mainView.reloadListCollectionView()
            } catch {
                self.error = error.localizedDescription
            }
        }
    }

    @objc private func hideKeyboard(_ sender: UIView) {
        sender.endEditing(true)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
              let dataSource = collectionView.dataSource as? (any CollectionDataSourceProtocol) else { return }
        
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }

        animator.addCompletion { _ in
            let returnAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
                cell.transform = .identity
            }
            returnAnimator.startAnimation()
        }

        animator.startAnimation()

        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
        let movie = dataSource.getItemByIndex(indexPath.item) as! Movie
        var movieForDetailView: Movie?
        Task {
            do {
                if CoreDataManager.shared.isSaved(movieID: movie.id) {
                    movieForDetailView = CoreDataManager.shared.fetchSavedMovie(with: movie.id)!
                } else {
                    movieForDetailView = try await dataManager.obtainDetailInfoById(id: movie.id)
                }
            } catch {
                guard let fullMovie = CoreDataManager.shared.fetchMovieEntity(with: movie.id) else {
                    detailViewController.error = error.localizedDescription
                    return
                }
                movieForDetailView = fullMovie
            }
            detailViewController.configure(with: movieForDetailView)
        }
    }
}

extension MainViewController: NextButtonDelegate {
    func obtainNextMoviesPage(completion: @escaping ()->()) {
        Task {
            do {
                let movies = try await self.dataManager.obtainNextPageAllMovies()
                
                self.mainView.listCollectionView.performBatchUpdates {
                    self.allMoviesDataSource.addItems(movies)
                    let items = self.allMoviesDataSource.getItems()
                    let newIndexPaths = ((items.count - movies.count)..<items.count).map { IndexPath(item: $0, section: 0) }
                    self.mainView.listCollectionView.insertItems(at: newIndexPaths)
                    completion()
                }
            } catch {
                let alert = UIAlertController(title: "", message: "Что-то пошло не так. Проверьте соединение с интеренетом", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
                completion()
            }
        }
    }
}

extension MainViewController: SearchIconDelegate {
    func findMovieByName(name: String) {
        guard !name.isEmpty else { return }
        let allItems = allMoviesDataSource.getItems() + topListDataSource.getItems()
        if let movie = allItems.first(where: {$0.title.lowercased() == name.lowercased()}) {
            Task {
                let detailViewController = DetailViewController()
                navigationController?.pushViewController(detailViewController, animated: true)
                let detailMovie = try await dataManager.obtainDetailInfoById(id: movie.id)
                detailViewController.configure(with: detailMovie)
            }
        } else {
            let alert = UIAlertController(title: "", message: "Фильма с таким названием не найдено", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
}
