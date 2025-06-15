//
//  MainView.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import UIKit

final class MainView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Мои напоминания"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifer)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
    
}
