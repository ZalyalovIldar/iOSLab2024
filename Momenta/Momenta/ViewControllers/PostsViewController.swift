//
//  PersonalPostsViewController.swift
//  Momenta
//
//  Created by Тагир Файрушин on 15.10.2024.
//

import UIKit

class PostsViewController: UIViewController {
    
    // MARK: - Properties
    
    enum SectionDataSource{
        case main
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.backgroundColor = .systemGray6
        table.separatorStyle  = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
        return table
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Momenta"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80))
        headerView.backgroundColor = .systemGray6
        // headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private lazy var headerCountRecordsLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.posts.count) записей"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerRecordsIconImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "square.stack"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var headerRecordsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerRecordsIconImageView,
            headerCountRecordsLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var posts: [Post] = [
        Post(id: UUID(),
             date: Date(),
             title: "Новые детали",
             text: """
             Промодельная рама дикого Lewis Mills'а. Усиления и баттинг где только можно, овализированные трубы чейнстея, 8мм дропауты и бомбические расцветки.
             """,
             images: [UIImage(named: "рамаMills")!, UIImage(named: "седлоMills")!]
        ),
    ]
    
    var dataSource: UITableViewDiffableDataSource<SectionDataSource, Post>?
    
    private let headerSpacingConstant: CGFloat = 20
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupLayout()
        setupNavigationBar()
        setupLayoutHeader()
        setupDataSource()
    }
    
    // MARK: - Setup Subview
    
    private func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupLayoutHeader() {
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerRecordsStackView)
        
        tableView.tableHeaderView = headerView
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: headerSpacingConstant),
            
            headerRecordsStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 2),
            headerRecordsStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -headerSpacingConstant),
        ])
    }
    
    private func updateHeaderCountLabel() {
        headerCountRecordsLabel.text = "\(self.posts.count) записей"
    }
    
    // MARK: - SetupDataSource
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, post in
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as! PostTableViewCell
            cell.configureCell(with: post)
            cell.selectionStyle = .none
            return cell
        })
        applySnapshot(posts: self.posts, animation: false)
    }
    
    private func applySnapshot(posts: [Post], animation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionDataSource,Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot,animatingDifferences: animation)
    }
    
    // MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .systemGray6

        let action = UIAction { [weak self] _ in
            let createPostVC = CreatePostViewController()
            createPostVC.savePostClosure = {[weak self] post in
                guard let self = self else { return }
                self.posts.append(post)
                self.applySnapshot(posts: posts, animation: true)
                updateHeaderCountLabel()
            }
            let createPostNVC = UINavigationController(rootViewController: createPostVC)
            self?.present(createPostNVC, animated: true, completion: nil)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
}

// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = dataSource?.itemIdentifier(for: indexPath) {
            let detailPostViewController = DetailPostViewController(with: post, delegate: self)
            
            detailPostViewController.updatePostClosure = { [weak self] updatePost in
                guard let self = self else { return }
                self.posts[indexPath.item] = updatePost
                self.applySnapshot(posts: posts, animation: false)
            }
            
            navigationController?.pushViewController(detailPostViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

// MARK: - DetailPostControllerDelegate

extension PostsViewController: DetailPostControllerDelegate {
    func deletePost(with post: Post) {
        if let objectIndex = posts.firstIndex(where: { $0.id == post.id }){
            posts.remove(at: objectIndex)
            applySnapshot(posts: posts, animation: false)
            updateHeaderCountLabel()
        }
    }
}
