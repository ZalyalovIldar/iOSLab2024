//
//  ViewController.swift
//  Homework
//
//  Created by Anna on 01.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: InfoTableViewCell.reuseIdentifier)
        table.register(WorkExperienceTableViewCell.self, forCellReuseIdentifier: WorkExperienceTableViewCell.reuseIdentifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        return table
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "anya")
        return imageView
    }()
    
    var dataSource = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.append(User(name: "Васильева Анна", age: "18", city: "Чебоксары", workExperience: "2020-2022: менеджер новостного паблика о шоу-бизнесе\n2023-2024: менеджер онлайн-школы", avatarImage: UIImage(named: "anya")))
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(avatarImageView)
        setupLayout()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            tableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
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
        switch indexPath.section {
        case 0: 
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.reuseIdentifier, for: indexPath) as! InfoTableViewCell
            cell.configure(with: dataSource[0])
            return cell
        case 1: 
            let cell = tableView.dequeueReusableCell(withIdentifier: WorkExperienceTableViewCell.reuseIdentifier, for: indexPath) as! WorkExperienceTableViewCell
            cell.configure(with: dataSource[0])
            return cell
        case 2: 
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.reuseIdentifier, for: indexPath) as! PhotosTableViewCell
            cell.photos = [UIImage(named: "japan")!, UIImage(named: "paris")!, UIImage(named: "dog")!, UIImage(named: "flowers")!,]
            return cell
        default: 
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0: return 200
        default: return UITableView.automaticDimension
        }
    }
}
