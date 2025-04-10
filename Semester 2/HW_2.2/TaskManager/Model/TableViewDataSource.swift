//
//  TableViewDataSource.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 7.04.25.
//

import Foundation
import UIKit


class TableViewDataSource: NSObject {
    private let tableview: UITableView
    var dataSource: UITableViewDiffableDataSource<Sections, TaskItem>!
    
    
    init(tableview: UITableView) {
        self.tableview = tableview
        super.init()
        
        dataSource = UITableViewDiffableDataSource<Sections, TaskItem>(
            tableView: tableview)
            { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
                    cell.configureCell(with: item)
                    return cell
            }
        
        tableview.dataSource = dataSource
    }
    
    func applySnapshot(items: [TaskItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, TaskItem>()
        snapshot.appendSections([Sections.first])
        snapshot.appendItems(items, toSection: Sections.first)
        dataSource.apply(snapshot)
    }
}

