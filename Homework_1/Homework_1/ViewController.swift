//
//  ViewController.swift
//  Homework_1
//
//  Created by Дмитрий Леонтьев on 02.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        
        let table = UITableView()
        
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.estimatedRowHeight = 310
        table.rowHeight = UITableView.automaticDimension
        
        table.register(UINib(nibName: "UserFirstTableViewCell", bundle: nil), forCellReuseIdentifier: UserFirstTableViewCell.identifier)
        table.register(UserSecondTableViewCell.self, forCellReuseIdentifier: UserSecondTableViewCell.identifier)
        table.register(UserThirdTableViewCell.self, forCellReuseIdentifier: UserThirdTableViewCell.identifier)
        
        return table
    }()
    
    var dataSource: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarImage1 = UIImage(named: "avatar")!
        let avatarImage2 = UIImage(named: "avatar2")!
        let avatarImage3 = UIImage(named: "avatar3")!
        let avatarImage4 = UIImage(named: "avatar4")!
        
        dataSource = [User(avatar: avatarImage2,
                          FIO: "Леонтьев Дмитрий Михайлович",
                          age: "18",
                          cityOfResidence: "Казань",
                          workExperience: "23 года, дизайнер из Санкт-Петербурга",
                           photo: [avatarImage1,avatarImage2,avatarImage3,avatarImage4])]
        
        view.backgroundColor = .white
        view.addSubview(tableView)
                
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count * 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = dataSource.first else {
            return UITableViewCell()
        }
        
        if indexPath.row % 3 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserFirstTableViewCell.identifier, for: indexPath) as! UserFirstTableViewCell
            cell.configureCell(with: model)
            return cell
        } else if indexPath.row % 3 == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserSecondTableViewCell.identifier, for: indexPath) as! UserSecondTableViewCell
            cell.configureCell(with: model)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserThirdTableViewCell.identifier, for: indexPath) as! UserThirdTableViewCell
            cell.configureCell(with: model)
            return cell
        }
    }
}


