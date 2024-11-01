//
//  ViewController.swift
//  Ex1
//
//  Created by Терёхин Иван on 04.10.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let user = Profile(fullName: "Терехин Иван Николаевич",
                            age: "19",
                            city: "Пермь",
                            workExperience: "2020 - 2022: Участвовал в разработке веб-приложений с использованием React и Node.js. 2018 - 2020: Разрабатывал и выполнял тестовые сценарии для мобильных приложений. Проводил автоматизацию тестирования с использованием Selenium и Appium." ,
                            photos: ["photo1", "photo1", "photo1", "photo1", "photo1", "photo1", "photo1"],
                            avatar: "Profile")
    
    
    lazy var avatar: UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: user.avatar)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    
    lazy var profileTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(UINib(nibName: "AboutMeTableViewCell", bundle: nil),forCellReuseIdentifier: AboutMeTableViewCell.reuseIdentifier)
        
        table.register(WorkExperienceTableViewCell.self, forCellReuseIdentifier:
                        WorkExperienceTableViewCell.reuseIndentifier)
        
        table.register(PhotoScrollViewTableViewCell.self, forCellReuseIdentifier: PhotoScrollViewTableViewCell.reuseIdentifier)
        
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout(){
        view.backgroundColor = .white
        view.addSubview(profileTable)
        view.addSubview(avatar)
        
        
        
        
        NSLayoutConstraint.activate([
            profileTable.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
            profileTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
           return 3 // Убедитесь, что возвращаете 3
       }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = profileTable.dequeueReusableCell(withIdentifier: AboutMeTableViewCell.reuseIdentifier, for: indexPath) as! AboutMeTableViewCell
            cell.configure(with: user)
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = profileTable.dequeueReusableCell(withIdentifier: WorkExperienceTableViewCell.reuseIndentifier, for: indexPath) as! WorkExperienceTableViewCell
            cell.configure(with: user)
            return cell
        }
        else if indexPath.section == 2{
            let cell = profileTable.dequeueReusableCell(withIdentifier: PhotoScrollViewTableViewCell.reuseIdentifier, for: indexPath) as! PhotoScrollViewTableViewCell
            cell.configure(with: user.photos)
            
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "О себе"
        case 1:
            return "Опыт работы"
        case 2:
            return "Фото"
        default:
            return nil
        }
        
    }

}
