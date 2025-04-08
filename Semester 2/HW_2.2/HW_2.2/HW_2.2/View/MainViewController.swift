//
//  MainViewController.swift
//  HW_2.2
//
//  Created by Павел Калинин on 06.04.2025.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()
    private let mainView = MainView()
    private var taskListTableViewDataSource: TaskListTableViewDataSource?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupBindings()
    }
    
    private func setupNavigationBar() {
        //При нажатии на плюс показывает alert с полем для ввода
        let action = UIAction {[weak self] _ in
            let alert = UIAlertController(title: "Новая задача", message: "Введите текст", preferredStyle: .alert)
            
            let addAlertAction = UIAlertAction(title: "Добавить", style: .default) { action in
                if let text = alert.textFields?.first?.text, !text.isEmpty {
                    self?.mainViewModel.addTask(title: text)
                }
            }
            
            let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel)
            
            alert.addTextField()
            alert.addAction(addAlertAction)
            alert.addAction(cancelAlertAction)
            
            self?.present(alert, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    private func setupBindings() {
        mainViewModel.onTasksUpdated = {[weak self] _ in
            self?.taskListTableViewDataSource?.updateSnapshot(animation: true)
        }
    }
    
    private func setupTableView() {
        mainView.taskListTableView.delegate = self
        taskListTableViewDataSource = TaskListTableViewDataSource(viewModel: mainViewModel)
        taskListTableViewDataSource?.setupDataSource(tableView: mainView.taskListTableView)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainViewModel.toggleTaskCompletion(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.mainViewModel.deleteTask(at: indexPath.row)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
