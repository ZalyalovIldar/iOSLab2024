import UIKit

class MainBoardViewController: UIViewController, MainBoardDelegate{
    
    var posts: [Post] = []
    var dataSource: UITableViewDiffableDataSource<Int, Post>!
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainBoardTableViewCell.self, forCellReuseIdentifier: MainBoardTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        for _ in 0..<5 {
            posts.append(Post(date: setDate(), description: "Some short textsome short textsome short textsome short textsome short textsome short textsome short textsome short text", pictures: ["cats", "watermelon","army", "food", "sixfour", "the smile"], id: UUID()))
        }
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        setupLayout()
        setupNavigationBar()
        updateDataSource(with: posts)
        
    }
    
    private func setDate() -> String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Post>(tableView: tableView) { (tableView, indexPath, post) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: MainBoardTableViewCell.reuseIdentifier, for: indexPath) as! MainBoardTableViewCell
            cell.configureCell(with: post)
            return cell
        }
        updateDataSource(with: posts)
    }
    func updateDataSource(with posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    @objc func addButtonTapped() {
        let addVC = AddViewController()
        addVC.onSave = { [weak self] post in
            self?.handleNewPost(post)
        }
        let navigationController = UINavigationController(rootViewController: addVC)
        present(navigationController, animated: true, completion: nil)
    }
    func handleNewPost(_ post: Post) {
        posts.append(post)
        updateDataSource(with: posts)
    }
    func setupNavigationBar() {
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        updateDataSource(with: [Post(date: setDate(), description: "", pictures: [], id: UUID())])
    }
    func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func didDeletePost(_ post: Post) {
        if let index = posts.firstIndex(of: post) {
            posts.remove(at: index)
            updateDataSource(with: posts)
        }
    }
    func didUpdatePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index] = post
            updateDataSource(with: posts)
        }
    }


}
extension MainBoardViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        let detailVC = DetailsViewController()
        detailVC.post = selectedPost
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
protocol MainBoardDelegate: AnyObject {
    func didDeletePost(_ post: Post)
    func didUpdatePost(_ post: Post)
}
