//
//  ViewController2.swift
//  Movies
//
//  Created by Павел Калинин on 20.12.2024.
//
import CoreData
import UIKit

class WatchListViewController: UIViewController {
    private let dataManager = DataManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    private let watchListView = WatchListView()
    private var fetchResultsController: NSFetchedResultsController<SavedMovieEntity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        watchListView.collectionView.delegate = self
        watchListView.collectionView.dataSource = self
        
        fetchResultsController = coreDataManager.createPreparedFetchResultsController()
        fetchResultsController.delegate = self
        updateCollectionWithSavedMovies()
    }
    
    override func loadView() {
        view = watchListView
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController!.navigationBar
        navigationItem.title = "Избранное"
        navBar.tintColor = .white
    }

    private func updateCollectionWithSavedMovies() {
        do {
            try fetchResultsController.performFetch()
            watchListView.reloadSavedCollectionView()
        } catch {
            print("Couldn't update collection view with saved movies")
        }
    }
}

extension WatchListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            watchListView.collectionView.reloadData()
        case .delete:
            watchListView.collectionView.deleteItems(at: [indexPath!])
        @unknown default:
            fatalError("Неизвестный тип изменения")
        }
    }
}

extension WatchListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchListCollectionViewCell.reuseIdentifier, for: indexPath) as? WatchListCollectionViewCell,
              let movie = fetchResultsController.object(at: indexPath).toMovie() else {
            return UICollectionViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1,
                       animations: {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform.identity
            }
        })
        
        let movie = fetchResultsController.object(at: indexPath)
        let detailViewController = DetailViewController()
        detailViewController.configure(with: movie.toMovie())
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
