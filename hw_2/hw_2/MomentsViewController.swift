//
//  MomentsViewController.swift
//  hw_2
//
//  Created by Кирилл Титов on 21.11.2024.
//

import UIKit

final class MomentsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Post>!
    private var posts: [Post] = [] 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        setupNavigationBar()
        

        let sampleImage = UIImage(named: "ufasochi")
        let sampleImage2 = UIImage(named: "ufasochi2")
        let sampleImage3 = UIImage(named: "car")
        let sampleImage4 = UIImage(named: "roadToPolyana")

        let samplePost = Post(date: Date(), text: "Уфа-Сочи", images: [sampleImage, sampleImage2, sampleImage3, sampleImage4].compactMap { $0 })
        posts.append(samplePost)

        let sampleImage5 = UIImage(named: "dubai")
        let sampleImage6 = UIImage(named: "flyToDubai")
        let samplePost2 = Post(date: Date(), text: "Сочи-Дубай", images: [sampleImage5, sampleImage6].compactMap { $0 })
        posts.append(samplePost2)
        updateSnapshot()

        let sampleImage7 = UIImage(named: "nearHotel")
        let sampleImage8 = UIImage(named: "viewFromWindow")
        let sampleImage9 = UIImage(named: "burjKhalifa")
        let samplePost3 = Post(date: Date(), text: "😍", images: [sampleImage7, sampleImage8, sampleImage9].compactMap { $0 })
        posts.append(samplePost3)
        updateSnapshot()
        
        let sampleImage10 = UIImage(named: "wow")
        let sampleImage11 = UIImage(named: "marina")
        let samplePost4 = Post(date: Date(), text: "🏢🏢🏢", images: [sampleImage10, sampleImage11].compactMap { $0 })
        posts.append(samplePost4)
        updateSnapshot()
        
        let sampleImage12 = UIImage(named: "bingxCar2")
        let sampleImage13 = UIImage(named: "bingCar")
        let sampleImage14 = UIImage(named: "f1")
        let samplePost5 = Post(date: Date(), text: "🚗💨", images: [sampleImage12, sampleImage13, sampleImage14].compactMap { $0 })
        posts.append(samplePost5)
        updateSnapshot()
        
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.identifier)

        NSLayoutConstraint.activate([
                    collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
    }

    private func createLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10

            return UICollectionViewCompositionalLayout(section: section)
        }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Post>(collectionView: collectionView) { collectionView, indexPath, post -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.identifier, for: indexPath) as? PostCell else { return nil }
            cell.configure(with: post)
            return cell
        }
        updateSnapshot()
    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupNavigationBar() {
        title = "Моменты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
    }

    @objc private func addNewPost() {
        let createPostVC = CreatePostViewController()
        createPostVC.onPostCreated = { [weak self] post in
            self?.posts.append(post)
            self?.updateSnapshot()
        }
        let navController = UINavigationController(rootViewController: createPostVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

extension MomentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = PostDetailViewController(post: post)
        
        detailVC.onPostUpdated = { [weak self] updatedPost in
            if let index = self?.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                self?.posts[index] = updatedPost
                self?.updateSnapshot()
            }
        }
        
        detailVC.onPostDeleted = { [weak self] deletedPost in
            self?.posts.removeAll { $0.id == deletedPost.id }
            self?.updateSnapshot()
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
