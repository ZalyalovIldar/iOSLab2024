//
//  FavouriteFilmsView.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 15.01.25.
//

import UIKit

class FavouriteView: UIView {
    
    lazy var filmsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = SpacingConstants.width / 2
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = Colors.backgroud
        table.register(FavouriteFilmsCell.self, forCellReuseIdentifier: FavouriteFilmsCell.identifier)
        return table
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = Colors.backgroud
        addSubview(filmsTable)
        NSLayoutConstraint.activate([
            filmsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            filmsTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            filmsTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            filmsTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
