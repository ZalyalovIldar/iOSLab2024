//
//  FavoriteViewController.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 05.01.2025.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    private var favoriteView: FavoritesView {
        self.view as! FavoritesView
    }
    
    private var tableViewDataSource: TableViewDataSource?
    private var tableViewDelegate: TableViewDelegate?
    private var modelData = FavoriteModelData()
    
    override func loadView() {
        super.loadView()
        self.view = FavoritesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Color.backgroundColor
        configureNavigationBar()
    }
    
    private func configureTableView() {
        tableViewDataSource = TableViewDataSource(
            tableView: favoriteView.tableView,
            fetchResultController: modelData.fetchResultController)
        tableViewDelegate = TableViewDelegate(dataSource: tableViewDataSource, delegate: self)
        favoriteView.tableView.delegate = tableViewDelegate
    }
    
    private func configureFetchedResultsController() {
        modelData.fetchResultController.delegate = self
    }
    
    private func configureNavigationBar() {
        favoriteView.titleLabelNavigationItem.text = "Избранное"
        navigationItem.titleView = favoriteView.titleLabelNavigationItem
    }
}

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewDataSource?.applySnapshot(animated: false)
    }
}

extension FavoriteViewController: SelectedMovieDelegate {
    func pushDetailView(movieId: Int) {
        let detailViewController = DetailViewController(id: movieId)
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
