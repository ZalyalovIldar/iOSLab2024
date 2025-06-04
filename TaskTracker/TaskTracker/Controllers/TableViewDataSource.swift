//
//  TableViewDataSource.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import UIKit

final class TableViewDataSource: NSObject {
    var dataSource: UITableViewDiffableDataSource<TableSection, TaskItem>?
    var viewModel: TaskViewModel
    var tableView: UITableView
    
    init(tableView: UITableView, viewModel: TaskViewModel) {
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, taskItem in
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
            cell.configureCell(text: taskItem.text)
            return cell
        })
        applySnapshot(animated: false)
    }
    
    private func applySnapshot(animated: Bool) {
        var snapshot = dataSource?.snapshot() ?? NSDiffableDataSourceSnapshot<TableSection, TaskItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.taskData)
        
        dataSource?.apply(snapshot, animatingDifferences: animated)
        updateBackgroundView(isHidden: !snapshot.itemIdentifiers.isEmpty)
    }
    
    func updateItem(task: TaskItem, animated: Bool) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems([task])
        dataSource?.apply(snapshot, animatingDifferences: animated)
        updateBackgroundView(isHidden: !snapshot.itemIdentifiers.isEmpty)
    }
    
    func removeItem(task: TaskItem, animated: Bool) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteItems([task])
        dataSource?.apply(snapshot, animatingDifferences: animated)
        updateBackgroundView(isHidden: !snapshot.itemIdentifiers.isEmpty)
    }
    
    private func updateBackgroundView(isHidden: Bool) {
        DispatchQueue.main.async() {
            UIView.animate(withDuration: 0.15) {
                self.tableView.backgroundView?.isHidden = isHidden
            }
        }
    }
    
}
