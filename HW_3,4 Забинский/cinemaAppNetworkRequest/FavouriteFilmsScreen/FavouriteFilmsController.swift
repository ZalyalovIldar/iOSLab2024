//
//  FavouriteFilmsViewController.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import UIKit
import CoreData

class FavouriteFilmsController: UIViewController {

    private var customView: FavouriteFilmsView {
        view as! FavouriteFilmsView
    }
    private let dataManager = FavouriteFilmsDataManager()
    private var fetchedResultController: NSFetchedResultsController<FavouriteFilmEntity>!
    
    override func loadView() {
        super.loadView()
        view = FavouriteFilmsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableWithCachedData()
    }
    
    private func updateTableWithCachedData() {
        do {
            try fetchedResultController.performFetch()
            customView.favouriteFilmsTableView.reloadData()
        } catch {
            print("Fetch request failed with error: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultController = dataManager.createNSFetchedResultController()
        fetchedResultController.delegate = self
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupNavigationBar()
        setupDataSource()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = Colors.mainGray
        navigationItem.titleView = NavigationItemView(title: "Любимые фильмы")
    }
    
    private func setupDataSource() {
        customView.setDataSourceToFavouriteFilmsTableView(datasource: self)
    }
}

extension FavouriteFilmsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        customView.favouriteFilmsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        customView.favouriteFilmsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete, .update:
            if let indexPath = indexPath {
                customView.favouriteFilmsTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
}

extension FavouriteFilmsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteFilmsTableViewCell.identifier, for: indexPath) as! FavouriteFilmsTableViewCell
        let favouriteFilmEntity = fetchedResultController.object(at: indexPath)
        let favouriteFilm = FavouriteFilm(poster: Poster(image: favouriteFilmEntity.imagePath?.base64EncodedString() ?? ""),
                                          title: favouriteFilmEntity.title ?? "no title",
                                          rating: favouriteFilmEntity.rating,
                                          year: favouriteFilmEntity.year,
                                          runningTime: favouriteFilmEntity.runningTime,
                                          country: favouriteFilmEntity.country ?? "no country")
        cell.setupWithFilm(favouriteFilm)
        cell.isUserInteractionEnabled = false
        return cell
    }
}
