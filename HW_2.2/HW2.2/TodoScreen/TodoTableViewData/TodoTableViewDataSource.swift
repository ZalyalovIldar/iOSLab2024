//
//  TodoTableViewDataSource.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

enum Sections {
    case main
}

final class TodoTableViewDataSource: NSObject {
    
    private var viewModel: TodoViewModel!
    private var dataSource: UITableViewDiffableDataSource<Sections, Todo>?
    
    init(viewModel: TodoViewModel!) {
        self.viewModel = viewModel
    }
    
    func setupDataSource(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
        cellProvider: { tableView, indexPath, todo in
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
            cell.setup(todo)
            return cell
        })
        dataSource?.defaultRowAnimation = .fade
        updateSnapshot(animation: true)
    }
    
    func updateSnapshot(animation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Todo>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.todos)
        
        dataSource?.apply(snapshot, animatingDifferences: animation)
    }
    
    func addTodoToExistingSnapshot(item: Todo) {
        guard var snapshot = dataSource?.snapshot() else { return }
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems([item])
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func removeTodoFromExistingSnapshot(item: Todo) {
        guard var snapshot = dataSource?.snapshot() else { return }
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.deleteItems([item])
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
