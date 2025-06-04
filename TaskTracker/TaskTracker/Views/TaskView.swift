//
//  TaskView.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import UIKit

final class TaskView: UIView {
    
    private enum Constraints: CGFloat {
        case verticalPadding = 20
        case horizontalPadding = 15
    }

    private(set) lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: -Constraints.verticalPadding.rawValue, left: 0, bottom: 0, right: 0)
        
        let emptyLabel = UILabel()
        emptyLabel.text = "Нет задач"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textAlignment = .center
        tableView.backgroundView = emptyLabel
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
