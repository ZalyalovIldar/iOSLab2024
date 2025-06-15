//
//  TaskListViewController.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate {
    private var taskListView = TaskListView()
    private var dataSource: UITableViewDiffableDataSource<TableSection, TaskItem>?
    private var viewModel: TaskListViewModel
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = taskListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        updateDataSource()
        setupNavigationBar()
        setupDelegate()
        setupBinding()
    }
    
    private func setupDelegate() {
        taskListView.delegate = self
    }
    
    private func setupBinding() {
        viewModel.onItemsUpdated = { [weak self] in
            guard let self else { return }
            self.updateDataSource()
        }
    }
        
    private func setupNavigationBar() {
        title = "Лист задач"
        lazy var addAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.addAlertToAddUser()
        }
        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func addAlertToAddUser() {
        AlertService.showAddTaskAlert(viewController: self) { [weak self] title, description in
            self?.viewModel.addTask(title: title, description: description)
            self?.updateDataSource()
        }
    }
}

//MARK: TableDiffableDataSource
enum TableSection: CaseIterable {
    case IncompletedTask
    case CompletedTask
    var title: String {
        switch self {
            case .CompletedTask: return "Выполненные задачи"
            case .IncompletedTask: return "Предстоящие задачи"
        }
    }
}

extension TaskListViewController {
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: taskListView.tableView,
                                                   cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTaskTableViewCell.reuseIndentifier,
                                                     for: indexPath) as? ListTaskTableViewCell
            cell?.configureCell(task: itemIdentifier)
            
            cell?.didPressButton = { [weak self] isSelected in
                guard let self else { return }
                var task = itemIdentifier
                task.isCompleted = isSelected
                self.viewModel.toggleTaskCompletion(task: task)
                updateDataSource()

            }
            self.dataSource?.defaultRowAnimation = .fade
            
            return cell
        })
        
    }
    
    private func updateDataSource() {
        var snaphot = NSDiffableDataSourceSnapshot<TableSection, TaskItem>()
        let tasks = viewModel.items
        let incompletedTask = tasks.filter( { !$0.isCompleted } )
        let completedTask = tasks.filter( { $0.isCompleted } )
        
        if !incompletedTask.isEmpty {
            snaphot.appendSections([.IncompletedTask])
            snaphot.appendItems(incompletedTask, toSection: .IncompletedTask)
        }
        
        if !completedTask.isEmpty {
            snaphot.appendSections([.CompletedTask])
            snaphot.appendItems(completedTask, toSection: .CompletedTask)
        }
        dataSource?.apply(snaphot, animatingDifferences: true)
    }
}

//MARK: TableCellDelegate
extension TaskListViewController: TableViewCellActionDelegate {
    func deleteTaskBy(id: Int) {
        AlertService.showDeleteConfirmation(viewController: self) { [weak self] in
            guard let self else { return }
            let currentTask = viewModel.items[id].id
            self.viewModel.deleteTask(by: currentTask)
        }
    }
}
