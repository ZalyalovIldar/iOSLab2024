//
//  TaskListTableViewDataSource.swift
//  HW_2.2
//
//  Created by Павел Калинин on 08.04.2025.
//
import UIKit

enum Sections {
    case main
}

final class TaskListTableViewDataSource: NSObject {
    
    private var viewModel: MainViewModel!
    private var dataSource: UITableViewDiffableDataSource<Sections, TaskItem>?
    
    init(viewModel: MainViewModel!) {
        self.viewModel = viewModel
    }
    
    func setupDataSource(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
        cellProvider: { tableView, indexPath, taskItem in
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.reuseIdentifier, for: indexPath) as! TaskListTableViewCell
            cell.configure(with: taskItem)
            return cell
        })
        dataSource?.defaultRowAnimation = .fade
        updateSnapshot(animation: true)
    }
    
    func updateSnapshot(animation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, TaskItem>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items)
        
        dataSource?.apply(snapshot, animatingDifferences: animation)
    }
    
    func addTaskToExistingSnapshot(item: TaskItem) {
        guard var snapshot = dataSource?.snapshot() else { return }
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems([item])
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func removeTaskFromExistingSnapshot(item: TaskItem) {
        guard var snapshot = dataSource?.snapshot() else { return }
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.deleteItems([item])
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
