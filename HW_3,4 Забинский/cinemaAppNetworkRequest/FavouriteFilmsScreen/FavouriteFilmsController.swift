//
//  FavouriteFilmsViewController.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import UIKit
import CoreData

class FavouriteFilmsController: UIViewController, NSFetchedResultsControllerDelegate {

    private var customView: FavouriteFilmsView {
        view as! FavouriteFilmsView
    }
    private let coreDataManager = CoreDataManager.shared
    private var dataSource: FavouriteFilmsTableViewDataSource?
    private var fetchedResultController: NSFetchedResultsController<FavouriteFilmEntity>!
    
    override func loadView() {
        super.loadView()
        view = FavouriteFilmsView()
        coreDataManager.setDelegate(updateFavouriteFilmsDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultController = coreDataManager.createNSFetchedResultController()
        fetchedResultController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTableData()
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
            dataSource?.updateData(films: coreDataManager.obtainFavouriteFilms())
            customView.reloadData()
        } catch {
            print("Failed during fetching data: \(error.localizedDescription)")
        }
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
        let favFilms = coreDataManager.obtainFavouriteFilms()
        dataSource = FavouriteFilmsTableViewDataSource(withFavFilms: favFilms)
        customView.setDataSource(dataSource: dataSource!)
    }
}

extension FavouriteFilmsController: UpdateFavouriteFilmsDelegate {
    func updateFavouriteFilms() {
        updateTableData()
    }
}
