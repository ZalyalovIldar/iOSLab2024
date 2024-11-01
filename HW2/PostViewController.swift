//
//  PostViewController.swift
//  HW2
//
//  Created by Терёхин Иван on 23.10.2024.
//

import UIKit



class PostViewController: UIViewController {
    
    enum TableSection {
        case first
    }
    
    private var posts: [Post] = MockData.shared
    private var dataSource: UITableViewDiffableDataSource<TableSection, Post>?
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIndentifier)
        return table
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDataSource()
        setupNavigationBar()
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(table)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Моменты"
        let action = UIAction { [weak self ] _ in
            guard let self = self else { return }
            let createPostVC = CreatePostsViewController()
            createPostVC.completion = {[ weak self ] post in
                self?.posts.append(post)
                self?.updateDataSource(with: self!.posts, animated: true)
                createPostVC.dismiss(animated: true)
            }
            let viewController = UINavigationController(rootViewController: createPostVC)
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
            
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action, menu: nil)
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: table, cellProvider: { tableView, indexPath, posts in
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIndentifier, for: indexPath) as! PostTableViewCell
            cell.configure(with: posts)
            return cell
        })
        updateDataSource(with: posts, animated: false)
        
    }
    private func updateDataSource(with post: [Post], animated: Bool) {
        var snaphot = NSDiffableDataSourceSnapshot<TableSection, Post>()
        snaphot.appendSections([.first])
        snaphot.appendItems(posts)
        dataSource?.apply(snaphot, animatingDifferences: animated)
        
    }
}
extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = dataSource?.itemIdentifier(for: indexPath) {
            let detailPostViewController = DetailedPostViewController(delegate: self, post: post)
            navigationController?.pushViewController(detailPostViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
extension PostViewController: DetailPostControllerDelegate {
    func updatePost(with post: Post) {
        if let objectIndex = posts.firstIndex(where: { $0.id == post.id }) {
            posts.remove(at: objectIndex)
            posts.insert(post, at: objectIndex)
            updateDataSource(with:posts, animated: true)

        }
    }
    
   
    
    func deletePost(with post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            guard var snapshot = dataSource?.snapshot() else { return }
            posts.remove(at: index)
            snapshot.deleteItems([post])
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}

