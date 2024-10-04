//
//  ViewController.swift
//  HW_1
//
//  Created by Damir Rakhmatullin on 2.10.24.
//

import UIKit

class ViewController: UIViewController {
    
    let dataSource = User(name: "Рахматуллин Дамир Русланович", age: 19, city: "Ижевск", avatarImage: UIImage(named: "ProfileAvatar"), workExperience: [Experience(year: 2023, experienceDescription: "cтажировка в комании ИННОТЕХ"), Experience(year: 2024, experienceDescription: "летняя практика в институте")], profilePhotos: [UIImage(named: "Cat"), UIImage(named: "Kitten")])
  
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.register(UINib(nibName: String(describing: AboutYourselfTableViewCell.self), bundle: nil), forCellReuseIdentifier: AboutYourselfTableViewCell.reuseIdentifier)
        table.register(WorkExperienceTableViewCell.self, forCellReuseIdentifier: WorkExperienceTableViewCell.reuseIdentifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()
    }
    
    func setupTableViewLayout() {
        view.addSubview(tableView);
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}

enum Sections {
    case aboutYourself, workExperience, photo
    init (numberOfSection: Int) {
        switch numberOfSection {
            case 0:
                self = .aboutYourself
            case 1:
                self = .workExperience
            case 2:
                self = .photo
            default:
                fatalError("Invalid number of Section")
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView(section: section)
    }
    
    func setupHeaderView(section: Int) -> UIView? {
        
        lazy var headerView: UIView = {
            let header = UIView()
            return header
        }()
        
        lazy var headerViewLable: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        headerView.addSubview(headerViewLable)
        
        NSLayoutConstraint.activate([
            headerViewLable.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerViewLable.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
        
      
        
        switch Sections(numberOfSection: section) {
            case .aboutYourself:
                let imageView = UIImageView(image: dataSource.avatarImage)
                imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                headerView.addSubview(imageView)
            
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                    imageView.topAnchor.constraint(equalTo: headerView.topAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: 100),
                    imageView.heightAnchor.constraint(equalToConstant: 100),
                ])
               
                headerViewLable.text = "О себе:"
            case .workExperience:
                headerViewLable.text = "Опыт работы:"
            case .photo:
                headerViewLable.text = "Фотографии:"
            }
        
        return headerView
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (Sections(numberOfSection: section)) {
        case .aboutYourself:
            140
        case .workExperience:
            10
        case .photo:
            10
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(numberOfSection: section) {
            case .aboutYourself:
                1
            case .workExperience:
                dataSource.workExperience.count
            case .photo:
                1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(Sections(numberOfSection: indexPath.section)) {
            case .aboutYourself:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutYourselfTableViewCell.self))
                    as! AboutYourselfTableViewCell
                cell.configure(name: dataSource.name, age: String(dataSource.age), city: dataSource.city)
                return cell
            case .workExperience:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkExperienceTableViewCell.self))
                    as! WorkExperienceTableViewCell
                cell.configure(year: String(dataSource.workExperience[indexPath.row].year),
                           description: dataSource.workExperience[indexPath.row].experienceDescription)
                return cell
            case .photo:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self)) as! PhotosTableViewCell
                cell.configure(photosData: [UIImage(named: "Cat")!, UIImage(named: "Kitten")!])
                return cell
        }
        
    }
    
    
    
}

