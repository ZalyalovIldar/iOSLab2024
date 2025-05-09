//
//  ViewController.swift
//  UserSummary
//
//  Created by Тагир Файрушин on 26.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "FirstSectionTableViewCell", bundle: nil), forCellReuseIdentifier: FirstSectionTableViewCell.reuseIdentifier)
        table.register(SecondSectionTableViewCell.self, forCellReuseIdentifier: SecondSectionTableViewCell.reuseIdentifier)
        table.register(ThirdSectionTableViewCell.self, forCellReuseIdentifier: ThirdSectionTableViewCell.reuseIdentifier)
        return table
    }()

    var dataSource = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.append(User(fullName: "Файрушин Тагир Ленарович", age: "19", currentPlace: "Казань",descriptionJob: "Летняя практика по IOS-разработке", avatar: UIImage(named: "avatar")))
        view.addSubview(tableView)
        setupLayout()
        setupHeaderTableView()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupHeaderTableView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        headerView.backgroundColor = .white
        let imageView = UIImageView(image: dataSource[0].avatar)
        
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(shadowView)
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)  // Смещение тени
        shadowView.layer.shadowRadius = 10
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            shadowView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            shadowView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: 160),
            shadowView.heightAnchor.constraint(equalToConstant: 160),
            
            imageView.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])

        imageView.layer.cornerRadius = 80
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        tableView.tableHeaderView = headerView
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: FirstSectionTableViewCell.reuseIdentifier, for: indexPath) as! FirstSectionTableViewCell
            cell.configurateCell(with: dataSource[0])
            return cell
            
        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: SecondSectionTableViewCell.reuseIdentifier, for: indexPath) as! SecondSectionTableViewCell
            cell.configureCell(with: dataSource[0])
            return cell
        case 2: let cell = tableView.dequeueReusableCell(withIdentifier: ThirdSectionTableViewCell.reuseIdentifier, for: indexPath) as! ThirdSectionTableViewCell
            cell.photos = [UIImage(named: "Кремлевская 18")!, UIImage(named: "Кремлевская 35")!, UIImage(named: "Бутлерова 4")!]
            return cell
        default: return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0: return 200
        default: return UITableView.automaticDimension
        }
    }
    
    
}
