//
//  ViewController.swift
//  JSONParcingTest
//
//  Created by Данил Забинский on 20.03.2025.
//

import UIKit

final class JokesController: UIViewController {
    
    private var viewModel: JokesViewModel
    private var jokesDataSource: JokesTableViewDataSource?
    private var jokesData: [Joke]!
    
    private var jokesView: JokesView {
        view as! JokesView
    }
    
    override func loadView() {
        view = JokesView(viewModel: viewModel)
    }
    
    init(viewModel: JokesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        jokesData = viewModel.loadJokes(fromPath: "jokes")
        self.jokesDataSource = JokesTableViewDataSource(data: jokesData)
        jokesView.jokesTable.dataSource = jokesDataSource
        print("complete")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

