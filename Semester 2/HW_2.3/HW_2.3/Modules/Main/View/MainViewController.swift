//
//  MainViewController.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//

import UIKit

class MainViewController: UIViewController {
    var presenter: MainPresenterInput?

    private let mainView = MainView()
    private(set) lazy var dataSource: ReminderDataSource = {
        ReminderDataSource()
    }()
    private(set) lazy var delegate: ReminderDelegate = {
        ReminderDelegate(viewController: self)
    }()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        mainView.tableView.dataSource = dataSource
        mainView.tableView.delegate = delegate
    }

    private func setupNavBar() {
        let addAction = UIAction {[weak self] _ in
            self?.presenter?.showAddReminderModule()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
    }

    func updateUI(with reminders: [Reminder]) {
        dataSource.updateDataSource(with: reminders)
        mainView.tableView.reloadData()
    }
}
