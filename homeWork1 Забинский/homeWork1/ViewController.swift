//
//  ViewController.swift
//  homeWork1
//
//  Created by Данил Забинский on 24.09.2024.
//

import UIKit
class ViewController: UIViewController {
    // MARK: - Enum for determing table section
    enum TableSection: Int {
        case aboutMe = 1
        case workDescription = 3
        case collectionView = 5
    }
    
    // MARK: - Proprties
    private lazy var table: UITableView = {
        let table = UITableView()
        table.rowHeight = UITableView.automaticDimension
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.estimatedRowHeight = 200
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Datasource
    let dataSource: User =
        User(avatarImage: UIImage(named: "myAvatar"),
             fullName: "Забинский Данил Евгеньевич",
             age: 19,
             currentCity: "Казань",
             experience: [
                WorkPlace(yearOfHire: 2025, yearOfRelease: 2026, description: "Junior iOS developer, Т-банк,"),
                WorkPlace(yearOfHire: 2026, yearOfRelease: 2028, description: "Middle iOS developer, Авито,"),
                WorkPlace(yearOfHire: 2027, yearOfRelease: 2030, description: "Senior iOS developer, Сбербанк,"),
                WorkPlace(yearOfHire: 2030, yearOfRelease: 2030, description: "Lead iOS developer, Apple")
             ],
             information: [
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage(),
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage(),
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage(),
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage(),
                UIImage(named: "userPhotoData1") ?? UIImage(),
                UIImage(named: "userPhotoData2") ?? UIImage()
             ])

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        
        configurateTableHeaderView()
    }
    
    // MARK: - Private Methods
    private func setUpLayout() {
        view.backgroundColor = .white
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
     private func configurateTableHeaderView() {
         table.register(AvatarHeaderTableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        let headerViewFrame = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        
        let avatarCell = AvatarHeaderTableViewCell(style: .default, reuseIdentifier: UITableViewCell.identifier)
        
        avatarCell.configureWithUser(from: dataSource)
        
        headerViewFrame.addSubview(avatarCell)
        
        avatarCell.frame = headerViewFrame.bounds
        
        table.tableHeaderView = headerViewFrame
    }
}

// MARK: - Implementing Protocols Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableSection(rawValue: indexPath.row) {
        case .aboutMe, .workDescription, .collectionView:
            return UITableView.automaticDimension
        default:
            return 6
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.row) {
        case .aboutMe:
            return configureAboutMeCell(for: indexPath)
        case .workDescription:
            return configureWorkDescriptionCell(for: indexPath)
        case .collectionView:
            return configureCollectionViewCell(for: indexPath)
        default:
            return configureEmptyCell(for: indexPath)
        }
    }
    
    private func configureEmptyCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    private func configureAboutMeCell(for indexPath: IndexPath) -> UITableViewCell {
        table.register(UINib(nibName: "FirstTableViewCell", bundle: nil), forCellReuseIdentifier: UITableViewCell.identifier)
        
        let cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath) as! FirstTableViewCell
        
        cell.configureWithUser(from: dataSource)
        return cell
    }
    
    private func configureWorkDescriptionCell(for indexPath: IndexPath) -> UITableViewCell {
        table.register(SecondTableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        let cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath) as! SecondTableViewCell
        
        cell.configureWithUser(from: dataSource)
        return cell
    }
    
    private func configureCollectionViewCell(for indexPath: IndexPath) -> UITableViewCell {
        table.register(ThirdUITableViewCellCollectionView.self, forCellReuseIdentifier: UICollectionViewCell.identifier)
        
        let cell = table.dequeueReusableCell(withIdentifier: UICollectionViewCell.identifier, for: indexPath) as! ThirdUITableViewCellCollectionView
                
        cell.configureWithUser(from: dataSource)
        return cell
    }
}
