//
//  TasksViewController.swift
//  HW2.2
//
//  Created by Павел on 10.04.2025.
//

import UIKit

final class TasksViewController: UIViewController {
    
    private let tasksView: TasksView = .init()
    private let tasksViewModel = TasksViewModel()
    var addNewTask: (() -> Void)?
    
    
    override func loadView() {
        view = tasksView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksView.tasksTableView.dataSource = self
        tasksView.tasksTableView.delegate = self
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: onAddAction)
    }
    
    private lazy var onAddAction =  UIAction { [weak self] _ in
        let alert = UIAlertController(title: "New task",
                                      message: "Enter your task",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Print task here"
            textField.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) {[weak self] _ in
            let task = alert.textFields?.first?.text ?? ""
            self?.tasksViewModel.createTask(with: task)
        }
        let cancelAction = UIAlertAction(title: "Close", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self?.present(alert, animated: true)
    }
    
    private func setupCallbacks() {
        tasksViewModel.onTasksUpdated = { [weak self] in
            self?.tasksView.tasksTableView.reloadData()
        }
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.identifier, for: indexPath) as! TasksTableViewCell
        cell.configureCell(with: tasksViewModel.tasks.reversed()[indexPath.row])
        cell.setupCompletedCells(with: tasksViewModel.tasks[indexPath.row])
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksViewModel.updateCompletionOfTask(with: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]
            action, view, handler in
            guard let self else { return }
            self.tasksViewModel.deleteTask(task: self.tasksViewModel.tasks[indexPath.row])
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}


