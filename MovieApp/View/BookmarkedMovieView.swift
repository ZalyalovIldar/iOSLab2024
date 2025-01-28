//
//  FavouriteFilmsView.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

import UIKit

class BookmarkedMovieView: UIView, UITableViewDelegate {
    
    private lazy var favouriteFilmsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = Constants.screenWidth / 2
        table.separatorStyle = .none
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = Colors.mainGray
        table.register(BookmarkedMoviesTableViewCell.self, forCellReuseIdentifier: BookmarkedMoviesTableViewCell.identifier)
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
    
    func setDataSource(dataSource: BookmarkedMoviesTableViewDataSource) {
        favouriteFilmsTableView.dataSource = dataSource
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
