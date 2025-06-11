//
//  ViewController.swift
//  MVVMJen
//
//  Created by Артур Мавликаев on 11.04.2025.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel = TaskListViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.backgroundColor = .white
        setupTableView()
        setupAddButton()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }

    func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped)
        )
    }

    @objc func addTaskTapped() {
        let alert = UIAlertController(title: "Новая задача", message: "Введите название задачи", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Название задачи"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let taskTitle = alert.textFields?.first?.text, !taskTitle.isEmpty {
                self.viewModel.addTask(title: taskTitle)
                self.tableView.reloadData()
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = viewModel.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleTaskCompletion(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


