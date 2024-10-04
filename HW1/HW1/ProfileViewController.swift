//
//  ViewController.swift
//  HW1
//
//  Created by дилара  on 04.10.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    private let tableView = UITableView()
    private let user = User(avatar: "Image", name: "Emili", age: 30, city: "Paris", experience: [
        Experience(year: "2021", description: "Senior software engineer"),
        Experience(year: "2017", description: "Middle software engineer"),
        Experience(year: "2015", description: "School teacher")
    ], photos: ["Image", "Image1", "Image2", "Image3", "Image4", "Image5", "Image6"])

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        tableView.register(ExperienceTableViewCell.self, forCellReuseIdentifier: "ExperienceTableViewCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return user.experience.count
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.configure(with: user)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableViewCell", for: indexPath) as! ExperienceTableViewCell
            cell.configure(with: user.experience[indexPath.row])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as! PhotosTableViewCell
            cell.configure(with: user.photos.map { Photo(imageName: $0) })
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User"
        case 1:
            return "Work Experience"
        case 2:
            return "Photos"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
}
