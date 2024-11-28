//
//  ViewController.swift
//  homework2
//
//  Created by Ильнур Салахов on 20.10.2024.
//

import UIKit



class ViewController: UIViewController, EditPostDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        return tableView
    }()
    var posts:[Post]=[]
    var dataSource : UITableViewDiffableDataSource<Int, Post>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts = [Post(text: "qwe", date:Date(), images: [UIImage(named: "Image 1")]),Post(text: "fefsdjfj", date:Date(), images: [UIImage(named: "Image 1"),UIImage(named: "Image 2"),UIImage(named: "Image 3")])]
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setupNavigationBar()
        setupDataSource()
    }
    
    func setupDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, post in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
            cell.configure(with: post )
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int,Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot)
    }
    
    func setupNavigationBar(){
        let addAction = UIAction{ _ in
            self.addPost()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add,primaryAction: addAction,menu:nil)
    }
    func addPost() {
            let createPostVC = CreatePostViewController()
            createPostVC.delegate = self // Устанавливаем делегат
            let navController = UINavigationController(rootViewController: createPostVC)
            present(navController, animated: true, completion: nil)
        }
}

extension ViewController: CreatePostDelegate {
    func didCreatePost(_ post: Post) {
        posts.insert(post, at: 0)
        updateTableView()
    }
    
    func didUpdatePost(_ post: Post, at index: Int) {
            posts[index] = post
            updateTableView()
        }
        
        func didDeletePost(at index: Int) {
            posts.remove(at: index)
            updateTableView()
        }
    
    private func updateTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = PostDetailViewController()
        detailVC.post = post
        detailVC.delegate = self
        detailVC.index = indexPath.row
        navigationController?.pushViewController(detailVC, animated: true)
        
        // Снимаем выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


