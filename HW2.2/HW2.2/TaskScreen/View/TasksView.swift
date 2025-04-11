//
//  TasksView.swift
//  HW2.2
//
//  Created by Павел on 10.04.2025.
//

import UIKit

final class TasksView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: TasksTableViewCell.identifier)
        return tableView
    }()
    
    private func setupUI() {
        addSubview(tasksTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            tasksTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
