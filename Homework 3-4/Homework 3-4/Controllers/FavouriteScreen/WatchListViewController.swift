//
//  WatchListViewController.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 23.01.2025.
//

import UIKit
import CoreData

final class WatchListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 140)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBlack
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "В избранном ничего нет."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var favoriteFilms: [Film] = [] {
        didSet {
            collectionView.reloadData()
            emptyLabel.isHidden = !favoriteFilms.isEmpty
        }
    }
    
    private lazy var context = CoreDataManager.shared.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlack
        setupUI()
        fetchFavorites()
        collectionView.reloadData()
        
        navigationItem.title = "Избранное"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .lightBlack
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchFavorites() {
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        
        do {
            favoriteFilms = try context.fetch(fetchRequest)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch favorites: \(error)")
        }
    }

}

extension WatchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteFilms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteCollectionViewCell.identifier,
            for: indexPath
        ) as? FavoriteCollectionViewCell else {
            fatalError("Не удалось создать ячейку с идентификатором \(FavoriteCollectionViewCell.identifier)")
        }
        let film = favoriteFilms[indexPath.row]
        cell.configure(with: film)
        cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.animateSelection {
            let film = self.favoriteFilms[indexPath.row]
            let detailVC = DetailViewController()
            detailVC.film = film
            self.pushDetailViewController(detailVC)
        }
    }
    
    func pushDetailViewController(_ detailVC: DetailViewController) {
        guard let containerView = self.navigationController?.view else { return }
        
        detailVC.loadViewIfNeeded()
        
        detailVC.view.frame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        detailVC.view.setNeedsLayout()
        detailVC.view.layoutIfNeeded()
        
        detailVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        detailVC.view.alpha = 0
        
        containerView.addSubview(detailVC.view)
        containerView.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            detailVC.view.transform = .identity
            detailVC.view.alpha = 1
        }
        
        animator.addCompletion { _ in
            self.navigationController?.pushViewController(detailVC, animated: false)
            detailVC.view.removeFromSuperview()
        }
        
        animator.startAnimation()
    }

}


