//
//  TableViewDelegate.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import UIKit

final class TableViewDelegate: NSObject, UITableViewDelegate {
    private var viewModel: TaskViewModel
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
            guard let self,
                  let dataSource = tableView.dataSource as? UITableViewDiffableDataSource<TableSection, TaskItem>,
                  let task = dataSource.itemIdentifier(for: indexPath) else {
                completion(false)
                return
            }
            
            viewModel.removeTask(task: task)
            completion(true)
        }
        completeAction.backgroundColor = .systemBlue
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .medium)
        completeAction.image = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
}
