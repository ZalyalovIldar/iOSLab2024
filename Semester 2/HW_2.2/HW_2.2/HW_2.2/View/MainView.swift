//
//  MainView.swift
//  HW_2.2
//
//  Created by Павел Калинин on 08.04.2025.
//
import UIKit

class MainView: UIView {
    private(set) lazy var taskListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(taskListTableView)
        
        NSLayoutConstraint.activate([
            taskListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            taskListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            taskListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            taskListTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
