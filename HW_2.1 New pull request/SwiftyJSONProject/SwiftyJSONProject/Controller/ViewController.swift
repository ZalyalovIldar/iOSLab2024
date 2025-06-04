//
//  ViewController.swift
//  SwiftyJSONProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var mainView: MainView {
        self.view as! MainView
    }
    
    private var viewModel: ViewModel
    private var tableViewDataSource: TableViewDataSource?
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bingingLoadPassenger()
        configureTableView()
        viewModel.parseJSON("titanic")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView() {
        tableViewDataSource = TableViewDataSource(tableView: mainView.tableView)
    }
    
    func bingingLoadPassenger() {
        viewModel.updateTableView = { [weak self] passengers in
            guard let self else { return }
            self.tableViewDataSource?.applySnapshot(passengers: passengers)
        }
    }
}

