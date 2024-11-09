import UIKit

class DetailedPostViewController: UIViewController {
    
    var pictures: [String] = []
    var post: Post!
    weak var delegate: PostSelectionDelegate?
    
    private lazy var postDescription: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .white
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.cornerRadius = 5
        text.layer.borderWidth = 1
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.textAlignment = .left
        text.setContentHuggingPriority(.defaultLow, for: .horizontal)
        text.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return text
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.collectionView?.isPagingEnabled = false
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupNavigationBar()
        configureData(with: post)
    }
    
    func configureData(with post: Post){
        postDescription.text = post.text
        pictures = post.pictures
        photoCollectionView.reloadData()
        updateContentVisibility()
        setupHeight()
    }
    
    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        let contentView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [postDescription, deleteButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        scrollView.addSubview(photoCollectionView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            photoCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 10),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
                ])
    }
    
    private func updateContentVisibility() {
        if let stackView = (view.subviews.first?.subviews.first as? UIStackView) {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            if !pictures.isEmpty {
                stackView.addArrangedSubview(photoCollectionView)
            }
            if let descriptionText = postDescription.text, !descriptionText.isEmpty {
                stackView.addArrangedSubview(postDescription)
            }
            
            stackView.addArrangedSubview(deleteButton)
        }
    }
    
    func setupHeight() {
            var height: CGFloat
            switch pictures.count {
            case 1:
                height = 200
                photoCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
            case 2:
                height = 200
                photoCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
            case 3:
                height = 600
                photoCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
            case 4:
                height = 400
                photoCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
            default:
                height = 0
                photoCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }

    
    func setupNavigationBar() {
        navigationItem.title = "Детали"
        let editButton = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))

        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func editButtonTapped() {
        let addPostCreationVC = PostCreationViewController()
        addPostCreationVC.post = post
        addPostCreationVC.didPostCreated = { [weak self] updatedPost in
            self?.post = updatedPost
            self?.configureData(with: updatedPost)
            self?.delegate?.didUpdatePost(updatedPost)
            self?.setupHeight()
            self?.navigationController?.popViewController(animated: true)
        }
        let navigationController = UINavigationController(rootViewController: addPostCreationVC)
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonTapped() {
        let alerting = UIAlertController(title: "Удаление",
                                                message: "Вы уверены, что хотите удалить данный пост?",
                                                preferredStyle: .alert)

        let deleting = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            if let post = self?.post {
                self?.delegate?.didDeletePost(post)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alerting.addAction(deleting)
        alerting.addAction(cancel)
        present(alerting, animated: true, completion: nil)
    }
}

extension DetailedPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseIdentifier, for: indexPath) as! PictureCell
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if pictures.count == 1 {
            return CGSize(width: 200, height: 200)
        }else if pictures.count % 2 == 1 && indexPath.item == pictures.count-1{
            let width: CGFloat = photoCollectionView.frame.width
            return CGSize(width: width, height: 400)
        }else {
            let width: CGFloat = (photoCollectionView.frame.width - 10)/2
            return CGSize(width: width, height: 200)
        }
    }
}
