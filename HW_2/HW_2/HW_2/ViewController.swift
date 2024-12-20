//
//  ViewController.swift
//  HW_2
//
//  Created by Damir Rakhmatullin on 27.10.24.
//

import UIKit

class ViewController: UIViewController {
    private final let navigationTitle = "Галерея"
    
    enum TableSection {
        case main
    }
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.delegate = self
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        table.estimatedRowHeight = 120
        return table
    }()
    
    private var dataSource: UITableViewDiffableDataSource<TableSection, Post>?
    
    var posts: [Post] = [
          Post(id: UUID(),
               date: Date(),
               title: "Котеки",
               text: "КОТЕЕЕЕЕЕЕЕЕКИИИИИИИИИИИИИИИ ! просто милые котенки ооочень милый котята.",
               images: [UIImage(resource: .psychoCat), UIImage(resource: .smileKitten)]
          ),
      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
        setupDataSource()
    }
    
    
    private func setupDataSource() {
           dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, post in
               let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
               cell.configureCell(with: post)
               return cell
           })
           applySnapshot(posts: self.posts, animation: false)
    }
    
    private func setupNavigationBar() {
            navigationItem.title = navigationTitle
            
            let action = UIAction { [weak self] _ in
                let postVC = PostViewController()
                postVC.savePostClosure = {[weak self] post in
                    self?.addPost(post: post, animated: true)
                }
                let postNVC = UINavigationController(rootViewController: postVC)
                postNVC.modalPresentationStyle = .fullScreen
                self?.navigationController?.present(postNVC, animated: true)
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, post in
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
                   cell.configureCell(with: post)
            return cell
        })
        applySnapshot(posts: self.posts, animation: false)
    }
    
    private func applySnapshot(posts: [Post], animation: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot, animatingDifferences: animation)
    }
    
    private func addPost(post: Post, animated: Bool) {
        posts.append(post)
        if var snapshot = dataSource?.snapshot() {
            snapshot.appendItems([post], toSection: .main)
            dataSource?.apply(snapshot, animatingDifferences: animated)
        }
    }
    
    private func removePost(post: Post, animated: Bool) {
           guard let indexObject = posts.firstIndex(where: {$0.id == post.id }) else { return }
           posts.remove(at: indexObject)
           if var snapshot = dataSource?.snapshot() {
               snapshot.deleteItems([post])
               dataSource?.apply(snapshot, animatingDifferences: animated)
           }
       }
       
       private func updatePost(updatePost: Post, animated: Bool) {
           guard let indexObject = posts.firstIndex(where: { $0.id == updatePost.id }) else { return }
           
           posts[indexObject] = updatePost

           if var snapshot = dataSource?.snapshot() {
               if let item = snapshot.itemIdentifiers.first(where: { $0.id == updatePost.id }) {
                   snapshot.deleteItems([item])
                   snapshot.appendItems([updatePost], toSection: .main)
               } else {
                   snapshot.appendItems([updatePost], toSection: .main)
               }
               
               dataSource?.apply(snapshot, animatingDifferences: animated)
           }
       }
       
    
    

    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = dataSource?.itemIdentifier(for: indexPath) {
            let detailPostViewController = DetailViewController(with: post, delegate: self)
            
            detailPostViewController.updatePostClosure = { [weak self] updatePost in
                self?.updatePost(updatePost: updatePost, animated: false)
            }
            
            navigationController?.pushViewController(detailPostViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension ViewController: DetailPostControllerDelegate {
    func deletePost(with post: Post) {
        removePost(post: post, animated: false)
    }
}
