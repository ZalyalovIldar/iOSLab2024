//
//  FavoritesView.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit

class FavoritesView: UIView {
    
    lazy var titleLabelNavigationItem: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Bold", size: Constant.Font.large)
        label.textColor = .white
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        tableView.backgroundColor = Color.backgroundColor
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
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
