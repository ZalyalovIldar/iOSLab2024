//
//  ViewController.swift
//  homework1
//
//  Created by Лидия  on 04.10.2024.
//

import UIKit
struct Profile {
    let name: String
    let age: String
    let city: String
    let workExperience: String
    let photos: [String]
}


class ViewController: UIViewController {
    let profile = Profile(
            name: "Кот",
            age: "30 лет",
            city: "город Чебаркуль",
            workExperience: "2010-2016 - ловил рыбов\n2017-2022 - смотрел на звезды\n2023-2024 - прогал java",
            photos: ["photo1", "photo2","photo3"]
    )
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        
        return table
       
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
                                    
        tableView.register(ExperienceCell.self, forCellReuseIdentifier: ExperienceCell.reuseIdentifier)
        tableView.register(FirstSectionCell.self, forCellReuseIdentifier: FirstSectionCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Identifier")


        
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)

            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: profile.photos[0])
            imageView.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)])
            return cell
        }
           else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
            
            let titleLabel = UILabel()
            titleLabel.text = "Фото"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .center
            cell.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                titleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15)])
            
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
            cell.contentView.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                collectionView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)])
            cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
            return cell
        }
            
       else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: ExperienceCell.reuseIdentifier, for: indexPath) as! ExperienceCell
           let experience = profile.workExperience
            cell.experienceLabel.text = "Опыт работы"
            cell.descriptionLabel.text = experience.description
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: FirstSectionCell.reuseIdentifier, for: indexPath) as! FirstSectionCell
            cell.aboutMe.text="Обо мне"
            cell.name.text = profile.name
            cell.age.text=profile.age
            cell.city.text=profile.city
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        if let image = UIImage(named: profile.photos[indexPath.row]) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            cell.backgroundView = imageView
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

