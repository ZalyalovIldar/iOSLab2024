//
//  ViewController.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import UIKit
import Combine

enum TableSection {
    case main
}

final class MainViewController: UIViewController, MainPresenterOutput {
    private let reminderService = ServiceLocator.shared.configureReminderService()
    private let mainView: MainView = .init()
    private var cancellables = Set<AnyCancellable>()
    private var diffableDataSourcce: UITableViewDiffableDataSource<TableSection, Reminder>?
    var presenter: MainPresenterInput!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDataSource()
    }
    
    
    override func loadView() {
        view = mainView
    }
    
        
    private lazy var addAction = UIAction { [weak self] _ in
        self?.presenter.showAddReminderFlow()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = mainView.titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
    }
}

// MARK: DiffableDataSource
extension MainViewController {
    private func setupDataSource() {
        diffableDataSourcce = UITableViewDiffableDataSource(
            tableView: mainView.tableView,
            cellProvider: { tableView, indexPath, reminder in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: MainTableViewCell.reuseIdentifer,
                    for: indexPath) as? MainTableViewCell
                cell?.selectionStyle = .none
                cell?.configureCell(reminder: reminder)
                return cell
            })
    }
    
    func updateDataSource(reminders: [Reminder]) {
        var snaphot = NSDiffableDataSourceSnapshot<TableSection, Reminder>()
        snaphot.appendSections([.main])
        snaphot.appendItems(reminders)
        diffableDataSourcce?.apply(snaphot, animatingDifferences: true)
    }
}
