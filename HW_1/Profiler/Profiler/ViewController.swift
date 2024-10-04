//
//  ViewController.swift
//  Profiler
//
//  Created by Тимур Салахиев on 28.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.sectionHeaderTopPadding = 40
        
        table.register(AvatarTableViewCell.self, forCellReuseIdentifier: AvatarTableViewCell.reuseIdentifier)
        table.register(UINib(nibName: "UserBioTableViewCell", bundle: nil), forCellReuseIdentifier: UserBioTableViewCell.reuseIdentifier)
        table.register(ExperienceTableViewCell.self, forCellReuseIdentifier: ExperienceTableViewCell.reuseIdentifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        return table
    }()
    
    var dataSource: [User] = []
    
    var currentUserIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dataSource = [
            User(avatar: UIImage(named: "avatar")!,
                 fullName: "Salakhiev Timur Airatovich",
                 age: 19,
                 city: "Kazan",
                 workingExperience: 1,
                 photos: [
                    UIImage(named: "photo_1")!,
                    UIImage(named: "photo_2")!,
                    UIImage(named: "photo_3")!,
                    UIImage(named: "photo_4")!
                 ]
            )
        ]
        
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    


}
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleForHeaderInSection: String = ""
        if section == 1{
            titleForHeaderInSection = "О себе"
        }
        if section == 2{
            titleForHeaderInSection = "Опыт работы"
        }
        if section == 3{
            titleForHeaderInSection = "Фото"
        }
        return titleForHeaderInSection
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowsInSection = 0
        if section == 0{
            numberOfRowsInSection = 1
        }
        if section == 1{
            numberOfRowsInSection = 1
        }
        if section == 2{
            numberOfRowsInSection = 1
        }
        if section == 3{
            numberOfRowsInSection = 1
        }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        UserBioTableViewCell().user = dataSource[currentUserIndex]
        AvatarTableViewCell().user = dataSource[currentUserIndex]
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: AvatarTableViewCell.reuseIdentifier, for: indexPath) as! AvatarTableViewCell
        }
        if indexPath.section == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: UserBioTableViewCell.reuseIdentifier, for: indexPath) as! UserBioTableViewCell
        }
        if indexPath.section == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: ExperienceTableViewCell.reuseIdentifier, for: indexPath) as! ExperienceTableViewCell
        }
         if indexPath.section == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.reuseIdentifier, for: indexPath) as! PhotosTableViewCell
        }
        
        var backgroundConfiguration = cell.defaultBackgroundConfiguration()
        backgroundConfiguration.cornerRadius = 20
        cell.backgroundConfiguration = backgroundConfiguration
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightForRowAt = 0.0
        if indexPath.section == 0{
            heightForRowAt = 200
        }
        if indexPath.section == 1{
            heightForRowAt = 66
        }
        if indexPath.section == 2{
            heightForRowAt = 25
        }
        if indexPath.section == 3{
            heightForRowAt = 400
        }
        
        return heightForRowAt
    }
    
}
extension UITableViewCell{
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}


