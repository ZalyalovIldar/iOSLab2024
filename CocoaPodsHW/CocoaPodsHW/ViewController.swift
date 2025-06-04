//
//  ViewController.swift
//  CocoaPodsHW
//
//  Created by Павел on 21.03.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUsers()
        view.backgroundColor = .white
    }
    
    private lazy var usersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(UsersCollectionViewCell.self, forCellWithReuseIdentifier: UsersCollectionViewCell.identifier)
        return collection
    }()
    
    private func setupUI() {
        view.addSubview(usersCollectionView)
        
        NSLayoutConstraint.activate([
            usersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateUsers() {
        Task {
            users = await NetworkService.obtainUsers()
            usersCollectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersCollectionViewCell.identifier, for: indexPath) as! UsersCollectionViewCell
        cell.configureCell(with: users[indexPath.row])
        return cell
    }
    
}


