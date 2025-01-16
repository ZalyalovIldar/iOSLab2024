//
//  ViewController.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 27.10.2024.
//


import UIKit

final class ViewController: UIViewController, UITableViewDelegate {
    private var posts: [Post] = [
        Post(id: UUID(), date: Date(), text: "Первый пост с фото", images: [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]),
        Post(id: UUID(), date: Date(), text: "Пост без фото", images: nil)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        configureDataSource()
        setupData()
        navigationItem.title = "Моменты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
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

    private func setupData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PostItem>()
        snapshot.appendSections([.main])
        let postItems = posts.map { PostItem(post: $0) }
        snapshot.appendItems(postItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func addPost() {
        let editVC = EditPostViewController()
        editVC.completion = { [weak self] newPost in
            guard let self = self else { return }
            self.posts.append(newPost)
            self.setupData()
        }
        navigationController?.pushViewController(editVC, animated: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailPostViewController()
        detailVC.post = posts[indexPath.row]
        detailVC.updatePostClosure = { [weak self] updatedPost in
            guard let self = self else { return }
            self.posts[indexPath.row] = updatedPost
            self.setupData()
        }
        detailVC.deletePostClosure = { [weak self] in
            guard let self = self else { return }
            self.posts.remove(at: indexPath.row)
            self.setupData()
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.posts.remove(at: indexPath.row)
            self.setupData()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

enum Section {
    case main
}

struct PostItem: Hashable {
    let post: Post
    let id = UUID()
}
