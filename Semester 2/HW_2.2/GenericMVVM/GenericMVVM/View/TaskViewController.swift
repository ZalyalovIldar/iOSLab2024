//
//  TaskViewController.swift
//  GenericMVVM
//
//  Created by Anna on 13.04.2025.
//

import Foundation
import UIKit
class TaskViewController: UIViewController {
    private let viewModel = TaskViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadTasks()
    }
    
    private func setupUI() {
        title = "Tasks"
        view.backgroundColor = .white
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped)
        )
    }
    
    private func setupBindings() {
        viewModel.onTasksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func addTaskTapped() {
        let alert = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Task title"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else { return }
            self?.viewModel.addTask(title: title)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = viewModel.tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        content.secondaryText = task.isCompleted ? "Completed" : "Not Completed"
        cell.contentConfiguration = content
        
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.tasks[indexPath.row]
        viewModel.toggleTaskCompletion(task)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = viewModel.tasks[indexPath.row]
            viewModel.deleteTask(task)
        }
    }
}
