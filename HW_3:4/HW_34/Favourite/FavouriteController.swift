//
//  FavouriteFilmsViewController.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 15.01.25.
//

import UIKit
import CoreData

class FavouriteController: UIViewController {

    private var favouriteFilmsView: FavouriteView {
        view as! FavouriteView
    }
    private let manager = FavouriteDataManager()
    private lazy var fetchedResultController: NSFetchedResultsController<FavouriteFilmEntity>! = {
        manager.createFetchedResultController()
    }()
    private var favouriteFilms: [FavouriteFilm] = []
    
    override func loadView() {
        super.loadView()
        view = FavouriteView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController.delegate = self
        favouriteFilmsView.filmsTable.delegate = self
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTableData() {
        do {
            try fetchedResultController.performFetch()
            favouriteFilmsView.filmsTable.reloadData()
        } catch {
            print("Fetch request failed with error: \(error)")
        }
    }
    
    private func setup() {
        setupNavigationBar()
        setupDataSource()
    }
    
    private func setupNavigationBar() {
        let customView = CustomTitle()
        customView.setupWithTitle(title: "Смотреть позже")
        navigationItem.titleView = customView
    }
    
    private func setupDataSource() {
        favouriteFilms = manager.obtainFavouriteFilms()
        favouriteFilmsView.filmsTable.dataSource = self
    }
}

extension FavouriteController: NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        favouriteFilmsView.filmsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        favouriteFilmsView.filmsTable.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteFilmsCell.identifier, for: indexPath) as! FavouriteFilmsCell
        let favouriteFilmEntity = fetchedResultController.object(at: indexPath)
        let favouriteFilm = FavouriteFilm(poster:
                                            Poster(image: favouriteFilmEntity.imagePath?.base64EncodedString() ?? ""),
                                          title: favouriteFilmEntity.title ?? "no title",
                                          rating: favouriteFilmEntity.rating,
                                          year: favouriteFilmEntity.year,
                                          runningTime: favouriteFilmEntity.runningTime,
                                          country: favouriteFilmEntity.country ?? "no country")
        cell.configureWithFilm(favouriteFilm)
        cell.isUserInteractionEnabled = false
        return cell
    }
}

