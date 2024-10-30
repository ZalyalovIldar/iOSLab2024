//
//  ViewController.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 27.10.2024.
//
import UIKit

enum Section {
    case main
}

struct PostItem: Hashable {
    let post: Post
    let id = UUID() 
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var posts: [Post] = [
        Post(id: UUID(), date: Date(), text: "Первый пост с фото", images: [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]),
        Post(id: UUID(), date: Date(), text: "Пост без фото", images: [])
    ]

    private var dataSource: UITableViewDiffableDataSource<Section, PostItem>!

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.backgroundColor = .white
        return table
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить пост", for: .normal)
        button.addTarget(self, action: #selector(addPost), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(addButton)
        setupTableView()
        setupButton()
        configureDataSource()
        setupData()
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, PostItem>(tableView: tableView) { (tableView, indexPath, postItem) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.configure(with: postItem.post)
            return cell
        }
        tableView.dataSource = dataSource
    }

    private func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PostItem>()
        snapshot.appendSections([.main])
        let postItems = posts.map { PostItem(post: $0) }
        snapshot.appendItems(postItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func addPost() {
        let editVC = EditPostViewController()
        editVC.delegate = self
        editVC.post = nil
        navigationController?.pushViewController(editVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postItem = PostItem(post: posts[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.configure(with: postItem.post)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = EditPostViewController()
        editVC.delegate = self
        editVC.post = posts[indexPath.row]
        editVC.index = indexPath.row
        navigationController?.pushViewController(editVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let postItemToDelete = self.posts[indexPath.row]
            self.posts.remove(at: indexPath.row)
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([PostItem(post: postItemToDelete)])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ViewController: EditPostDelegate {
    func didUpdatePost(_ post: Post, at index: Int?) {
        if let index = index {
            posts[index] = post
        } else {
            posts.append(post)
        }
        setupData()
    }
}
