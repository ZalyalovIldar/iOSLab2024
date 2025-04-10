import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    private lazy var favoriteView = FavoritesView(frame: .zero)
    private var dataManager = DataManager()
    private var fetchedResultsController: NSFetchedResultsController<MovieFavoriteEntites>!
    private var tableViewDataSource: TableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        setupTableView()
    }
    
    override func loadView() {
        view = favoriteView
        navigationItem.title = "Избранное"
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<MovieFavoriteEntites> = MovieFavoriteEntites.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: CoreDataManager.shared.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch favorite movies: \(error)")
        }
    }
    
    private func setupTableView() {
        tableViewDataSource = TableViewDataSource(fetchedResultsController: fetchedResultsController)
        tableViewDataSource.onMoviesDetail = { [weak self] movieId in
            self?.getDetailMoviesById(movieId)
        }
        
        favoriteView.table.dataSource = tableViewDataSource
        favoriteView.table.delegate = tableViewDataSource
        favoriteView.table.reloadData()
    }
    
    private func getDetailMoviesById(_ id: Int64) {
        Task {
            guard let movieDetail = await dataManager.getDetailMovie(Int(id)) else { return }
            let detailVC = DetailMovieViewController(movieDetail: movieDetail)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                favoriteView.table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                favoriteView.table.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            fatalError("Unexpected NSFetchedResultsChangeType")
        }
    }
}
