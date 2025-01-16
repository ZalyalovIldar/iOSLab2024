//
//  TableViewDataSource.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 09.01.2025.
//

import Foundation
import UIKit
import CoreData

class TableViewDataSource: NSObject {
    var dataSource: UITableViewDiffableDataSource<TableViewSection, NSManagedObjectID>?
    private var fetchResultController: NSFetchedResultsController<MovieEntity>
    
    init(tableView: UITableView, fetchResultController: NSFetchedResultsController<MovieEntity>) {
        self.fetchResultController = fetchResultController
        super.init()
        setupDataSource(tableView: tableView)
    }
    
    private func setupDataSource(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, objectID in
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier, for: indexPath) as! FavoriteTableViewCell
            if let movie = try? CoreDataManager.shared.viewContext.existingObject(with: objectID) as? MovieEntity {
                cell.configureCell(movie: movie)
            }
            return cell
        })
        applySnapshot(animated: true)
    }
    
    func applySnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, NSManagedObjectID>()
        snapshot.appendSections([.main])
        let objects = fetchResultController.fetchedObjects ?? []
        snapshot.appendItems(objects.map { $0.objectID }, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
}
