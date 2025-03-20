//
//  JokesView.swift
//  JSONParcingTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit

final class JokesView: UIView {
    
    private var viewModel: JokesViewModel
    
    private(set) lazy var jokesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(JokeCell.self, forCellReuseIdentifier: JokeCell.identifier)
        return table
    }()
    
    init(viewModel: JokesViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension JokesView {
    
    func setup() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(jokesTable)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            jokesTable.topAnchor.constraint(equalTo: topAnchor),
            jokesTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            jokesTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            jokesTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
