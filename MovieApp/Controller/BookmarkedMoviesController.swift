//
//  FavouriteMovieController.swift
//  MovieApp
//
//  Created by Anna on 27.01.2025.
//

import UIKit
import CoreData

class BookmarkedMoviesController: UIViewController, NSFetchedResultsControllerDelegate {

    private var customView: BookmarkedMovieView {
        view as! BookmarkedMovieView
    }
    private let coreDataManager = CoreDataManager.shared
    private var dataSource: BookmarkedMoviesTableViewDataSource?
    private var fetchedResultController: NSFetchedResultsController<BookmarkedMovieEntity>!
    
    override func loadView() {
        super.loadView()
        view = BookmarkedMovieView()
        coreDataManager.setDelegate(updateBookmarkedMoviesDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultController = coreDataManager.createFetchedResultsController()
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
            dataSource?.updateData(films: coreDataManager.fetchBookmarkedMovies())
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
        let favFilms = coreDataManager.fetchBookmarkedMovies()
        dataSource = BookmarkedMoviesTableViewDataSource(withFavFilms: favFilms)
        customView.setDataSource(dataSource: dataSource!)
    }
}

extension BookmarkedMoviesController: UpdateBookmarkedMoviesDelegate {
    func updateBookmarkedMovies() {
        updateTableData()
    }
}
