//
//  FavouriteFilmsView.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import UIKit

class FavouriteFilmsView: UIView, UITableViewDelegate {
    
    lazy var favouriteFilmsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = Constants.screenWidth / 2
        table.separatorStyle = .none
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = Colors.mainGray
        table.register(FavouriteFilmsTableViewCell.self, forCellReuseIdentifier: FavouriteFilmsTableViewCell.identifier)
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        favouriteFilmsTableView.reloadData()
    }
    
    func setDataSourceToFavouriteFilmsTableView(datasource: UITableViewDataSource) {
        favouriteFilmsTableView.dataSource = datasource
    }
    
    private func setup() {
        self.backgroundColor = Colors.mainGray
        addSubview(favouriteFilmsTableView)
        NSLayoutConstraint.activate([
            favouriteFilmsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            favouriteFilmsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            favouriteFilmsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            favouriteFilmsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
