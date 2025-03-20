//
//  MainView.swift
//  SwiftyJSONProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import UIKit

class MainView: UIView {
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(tableView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ConstantConstraint.small),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstantConstraint.small),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ConstantConstraint.small),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ConstantConstraint.small)
        ])
    }
}
