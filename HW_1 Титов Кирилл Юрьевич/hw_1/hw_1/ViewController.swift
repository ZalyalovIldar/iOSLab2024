//
//  ViewController.swift
//  hw_1
//
//  Created by Кирилл Титов on 28.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView :UITableView = {
        
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        return table
    }()
    
    var dataSource: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [
                User(
                    fullName: "Kirill Titov",
                    age: 19,
                    city: "Kazan",
                    avatarImage: UIImage(named: "myAvatar"),
                    workExperience: [
                        WorkExperience(year: 2022, company: "ABC Company"),
                        WorkExperience(year: 2023, company: "XYZ Inc.")
                    ]
                )
            ]
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint (equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.backgroundColor = .white
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "О себе"
        case 1: return "Опыт работы"
        case 2: return "Фото"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = dataSource[indexPath.row]
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            cell.fullName.text = user.fullName
            cell.age.text = "\(user.age)"
            cell.city.text = user.city
            return cell
            
        case 1:
                let cell = UITableViewCell()
                cell.textLabel?.numberOfLines = 0
                
                var workExperienceText = ""
                for experience in user.workExperience {
                    workExperienceText += "\(experience.year) - \(experience.company)\n"
                }
                cell.textLabel?.text = workExperienceText
                
                return cell
            
        case 2:
            let cell = UITableViewCell()
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            let imageNames = ["myAvatar", "myImage2", "myImage3"]
            let imageViews = imageNames.map { imageName -> UIImageView in
                let imageView = UIImageView(image: UIImage(named: imageName))
                imageView.contentMode = .scaleAspectFit
                return imageView
            }
            
            var previousImageView: UIImageView?
            for imageView in imageViews {
                scrollView.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 120),
                    imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    imageView.leadingAnchor.constraint(equalTo: previousImageView?.trailingAnchor ?? scrollView.leadingAnchor),
                    imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                ])
                previousImageView = imageView
            }
            
            if let lastImageView = previousImageView {
                NSLayoutConstraint.activate([
                    lastImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    scrollView.heightAnchor.constraint(equalToConstant: 120)
                ])
            }
            
            cell.contentView.addSubview(scrollView)
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
