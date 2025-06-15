//
//  ListViewController.swift
//  HW_2
//
//  Created by Павел Калинин on 20.10.2024.
//


import UIKit

class ListViewController: UIViewController {
    enum TableSection {
        case main
    }
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(MomentTableViewCell.self, forCellReuseIdentifier: MomentTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<TableSection, Moment>?
    private var moments: [Moment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setupLayout()
        setupNavigationBar()
        setupDataSource()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MomentTableViewCell.reuseIdentifier) as? MomentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }
        
        updateDataSource(with: moments, animated: false)
    }
    
    private func updateDataSource(with moments: [Moment], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Moment>()
        snapshot.appendSections([.main])
        snapshot.appendItems(moments)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
    
    private func setupNavigationBar() {
        let addAction = UIAction { _ in
            let rootVC = EditMomentViewController()
            rootVC.completion = {[weak self] moment in
                guard let self = self else { return }
                self.moments.append(moment)
                updateDataSource(with: self.moments, animated: true)
                rootVC.dismiss(animated: true)
            }
            let vc = UINavigationController(rootViewController: rootVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        navigationItem.title = "Мои моменты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let moment = dataSource?.itemIdentifier(for: indexPath) else { return }
        let detailVC = DetailViewController(delegate: self, moment: moment)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListViewController: UpdateMomentDelegate {
    func updateMoment(moment: Moment) {
        if let objectIndex = moments.firstIndex(where: {$0.id == moment.id}) {
            moments.remove(at: objectIndex)
            moments.insert(moment, at: objectIndex)
            
            updateDataSource(with: moments, animated: true)
        }
    }
    
    func deleteMoment(moment: Moment) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteItems([moment])
        dataSource?.apply(snapshot)
    }
}
