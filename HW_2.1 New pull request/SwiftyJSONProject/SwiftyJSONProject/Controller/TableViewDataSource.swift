//
//  TableViewDataSource.swift
//  SwiftyJSONProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import Foundation
import UIKit

class TableViewDataSource: NSObject {
    private var dataSource: UITableViewDiffableDataSource<TableViewSection, Passenger>?
    
    init(tableView: UITableView) {
        super.init()
        setupDataSource(tableView: tableView)
    }

    private func setupDataSource(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, passenger in
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
            cell.configureCell(passanger: passenger)
            return cell
        })
    }
    
    func applySnapshot(passengers: [Passenger]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, Passenger>()
        snapshot.appendSections([.main])
        snapshot.appendItems(passengers)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
