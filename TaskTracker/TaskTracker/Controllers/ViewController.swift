//
//  ViewController.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    private var taskView: TaskView {
        self.view as! TaskView
    }
    
    private let viewModel: TaskViewModel
    
    private var dataSource: TableViewDataSource?
    private var delegate: TableViewDelegate?
    
    private lazy var addAction = UIAction { [weak self] _ in
        guard let self else { return }
        let alert = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
        
        let actionCreate = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            guard let self,
                  let text = alert.textFields?.first?.text,
                  !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            let task = TaskItem(text: text)
            viewModel.addTask(task: task)
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alert.addTextField { textField in
            textField.placeholder = "Введите задачу"
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCreate)
        
        present(alert, animated: true)
    }
    
    override func loadView() {
        self.view = TaskView()
    }
    
    init(taskViewModel: TaskViewModel) {
        viewModel = taskViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavigationBar()
        bindingUpdateView()
    }
    
    deinit {
        viewModel.saveData()
    }
    
    private func configureTableView() {
        dataSource = TableViewDataSource(tableView: taskView.tableView, viewModel: viewModel)
        delegate = TableViewDelegate(viewModel: viewModel)
        taskView.tableView.delegate = delegate
    }

    private func bindingUpdateView() {
        viewModel.updateItem = { [weak self] task in
            guard let self else { return }
            dataSource?.updateItem(task: task, animated: true)
        }
        
        viewModel.removeItem = { [weak self] task in
            guard let self else { return }
            dataSource?.removeItem(task: task, animated: false)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        navigationItem.title = "TaskTracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: addAction)
    }
}

