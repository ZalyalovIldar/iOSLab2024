//
//  UserTableViewCell.swift
//  HW_1
//
//  Created by Артур Мавликаев on 02.10.2024.
//


import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "UserFirstSectionTableViewCell", bundle: nil), forCellReuseIdentifier: UserFirstSectionTableViewCell.identifier)
        table.register(UserSecondSectionTableViewCell.self, forCellReuseIdentifier: UserSecondSectionTableViewCell.reuseIdentifier)
        table.register(UserThirdSectionTableViewCell.self, forCellReuseIdentifier: "UserThirdSectionTableViewCell")
        table.backgroundColor = .white
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setConstraints()
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserFirstSectionTableViewCell.identifier, for: indexPath) as! UserFirstSectionTableViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserSecondSectionTableViewCell.reuseIdentifier, for: indexPath) as! UserSecondSectionTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserThirdSectionTableViewCell", for: indexPath) as! UserThirdSectionTableViewCell
            let images = [
                UIImage(named: "1"),
                UIImage(named: "2"),
                UIImage(named: "3")
            ]
            cell.configure(with: images.compactMap { $0 })
            return cell
        }
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
