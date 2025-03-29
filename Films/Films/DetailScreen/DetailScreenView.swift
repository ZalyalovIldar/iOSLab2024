//
//  DetailScreenView.swift
//  Films
//
//  Created by Артур Мавликаев on 10.01.2025.
//


import UIKit

final class DetailScreenView: UIView {
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor(
            red: 36/255,
            green: 42/255,
            blue: 50/255,
            alpha: 1
        )
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(
                red: 36/255,
                green: 42/255,
                blue: 50/255,
                alpha: 1
            )
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(PosterCell.self, forCellReuseIdentifier: PosterCell.identifier)
        tableView.register(TrailerButtonCell.self, forCellReuseIdentifier: TrailerButtonCell.identifier)
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
