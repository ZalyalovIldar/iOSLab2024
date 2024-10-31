import UIKit

protocol PostSelectionDelegate: AnyObject {
    func didDeletePost(_ post: Post)
    func didUpdatePost(_ post: Post)
}

class ViewController: UIViewController, PostSelectionDelegate {
    
    var posts: [Post] = []
    var dataSource: UITableViewDiffableDataSource<Int, Post>?
    weak var delegate: PostSelectionDelegate?
    
    lazy var postsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.delegate = self
        table.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupNavigationBar()
        loadPosts()
        configureDataSource()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupDate() -> String{
        let curDate = Date()
        let dateFormating = DateFormatter()
        dateFormating.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormating.string(from: curDate)
        return dateString
    }
    
    func loadPosts(){
        posts.append(contentsOf: [Post(text: "Apple представили новый Macbook Pro с чипами M4, M4 Pro и M4 Max. Сообщается, что старт продаж начнётся с 8 ноября, а цены на базовые модели будут варьироваться от 1600$ и 3200$", date: setupDate(), pictures: ["PostImage1", "PostImage2", "PostImage3"], id: UUID())])
        posts.append(contentsOf: [Post(text: "The Witcher 3 получила три новых фанатских DLC. Они стали победителями в официальном конкурсе от CD Project Red. Каждый мод имеет свою сюжетнюю линию, уникальные квесты и снаряжения, а также новые противники. Все дополнения бесплатны для загрузки. ", date: setupDate(), pictures: ["PostImage4", "PostImage5", "PostImage6"], id: UUID())])
        posts.append(contentsOf: [Post(text: "В Польше изобрели переворачиватель коров. Спецификации, назначение и цена данного устройства остаются в тайне, однако сообщается, что работы над ним велись в течение нескольких десятков лет. (Данная новость несёт исключительно развелательный характер и не является правдой)", date: setupDate(), pictures: ["PostImage7"], id: UUID())])
        posts.append(contentsOf: [Post(text: "Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4.Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4. Тестовый пост N4.", date: setupDate(), pictures: ["PostImage8", "PostImage8", "PostImage8"], id: UUID())])
        posts.append(contentsOf: [Post(text: "Информация для постов закончилась", date: setupDate(), pictures: ["PostImage9"], id: UUID())])
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Post>(tableView: postsTableView) { (tableView, indexPath, post) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
            cell.configureCell(with: post)
            return cell
        }
        updateDataSource(with: posts)
    }
    
    func handleNewPost(_ post: Post) {
        posts.append(post)
        updateDataSource(with: posts)
    }
    

    func updateDataSource(with posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func setupView(){
        view.backgroundColor = .white
        view.addSubview(postsTableView)
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Лента"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        updateDataSource(with: [Post(text: "", date: setupDate(), pictures: [], id: UUID())])
    }
    
    @objc func addButtonTapped() {
        let addPostViewController = PostCreationViewController()
        addPostViewController.didPostCreated = { [weak self] post in
            self?.handleNewPost(post)
        }
        let navigationController = UINavigationController(rootViewController: addPostViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func didDeletePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts.remove(at: index)
            updateDataSource(with: posts)
        }
    }
    
    func didUpdatePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index] = post
            updateDataSource(with: posts)
        } else {
            print(posts)
        }
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let DetailedViewController = DetailedPostViewController()
        let selectedPost = posts[indexPath.row]
        DetailedViewController.post = selectedPost
        DetailedViewController.delegate = self
        navigationController!.pushViewController(DetailedViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

