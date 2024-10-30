import UIKit

class DetailsViewController: UIViewController {
    var photos: [String] = []
    var post: Post!
    weak var delegate: MainBoardDelegate?
    private lazy var postDescription: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.systemGray5.cgColor
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 5
        text.textAlignment = .left
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.setContentHuggingPriority(.defaultLow, for: .horizontal)
        text.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return text
    }()
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 250, height: 250)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
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
        postDescription.text = post.description
        photos = post.pictures
        photoCollectionView.reloadData()
    }
    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        let contentView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [photoCollectionView, postDescription, deleteButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 10),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 300),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    func setupNavigationBar() {
        navigationItem.title = "Details"
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    @objc private func editButtonTapped() {
        let addViewController = AddViewController()
        addViewController.post = post
        addViewController.onSave = { [weak self] updatedPost in
            self?.post = updatedPost
            self?.configureData(with: updatedPost)
            self?.delegate?.didUpdatePost(updatedPost)
        }
        let navigationController = UINavigationController(rootViewController: addViewController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func deleteButtonTapped() {
        let alertController = UIAlertController(title: "Подтверждение",
                                                message: "Вы уверены, что хотите удалить этот пост?",
                                                preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            if let post = self?.post {
                self?.delegate?.didDeletePost(post)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        cell.imageView.image = UIImage(named: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if photos.count == 1 {
            return CGSize(width: 200, height: 200)
        }else if photos.count % 2 == 1 && indexPath.item == photos.count-1{
            let image = UIImage(named: photos[indexPath.item])!
            let aspectRatio = image.size.height/image.size.width
            let width: CGFloat = photoCollectionView.frame.width
            let height: CGFloat = width * aspectRatio
            return CGSize(width: width, height: height)
        }else {
            let image = UIImage(named: photos[indexPath.item])!
            let aspectRatio = image.size.height/image.size.width
            let width: CGFloat = (photoCollectionView.frame.width-10)/2
            let height: CGFloat = width * aspectRatio
            return CGSize(width:width, height: height)
        }
    }
}
