//
//  DetailPostViewController.swift
//  Momenta
//
//  Created by Тагир Файрушин on 17.10.2024.
//

import UIKit

// MARK: - DetailPostControllerDelegate

protocol DetailPostControllerDelegate: AnyObject {
    func deletePost(with: Post)
}

class DetailPostViewController: UIViewController {
    
    // MARK: - Enum Collection Cell Section
    
    enum SectionCollectionCell {
        case main
    }
    
    // MARK: - Properties
    
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = currentPost.title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = currentPost.text
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = dateFormater.string(from: currentPost.date)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 15
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var postStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            postPhotosCollectionView,
            postTitleLabel,
            postTextLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var deletePostAction: UIAction = UIAction { _ in
        let allert = UIAlertController(title: "Вы точно хотите удалить?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { UIAlertAction in
            self.delegate?.deletePost(with: self.currentPost)
            self.navigationController?.popViewController(animated: true)
        }
        allert.addAction(cancelAction)
        allert.addAction(deleteAction)
        self.present(allert, animated: true)
    }
    
    private lazy var editPostAction: UIAction = UIAction { _ in
        let editVC = CreatePostViewController(post: self.currentPost)
        editVC.savePostClosure = { [weak self] updatedPost in
            guard let self = self else { return }
            
            self.currentPost = updatedPost
            postTextLabel.text = currentPost.text
            postTitleLabel.text = currentPost.title
            if let images = currentPost.images {
                photos = images
                applySnapshotCollection(with: photos, animated: false)
            }
        
            self.updatePostClosure?(updatedPost)
            self.dismiss(animated: true)
        }
        
        let edinNVS = UINavigationController(rootViewController: editVC)
        self.present(edinNVS, animated: true)
    }
    
    private let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d yyyy"
        return formatter
    }()
    
    private let spacingConstant: CGFloat = 10
    
    private var photos: [UIImage] = [UIImage]()
    
    private var postCollectionViewHeightConstraint: NSLayoutConstraint?
    
    private var currentPost: Post!
    
    private weak var delegate: DetailPostControllerDelegate?
    
    // MARK: - Delegate Closure
    
    var updatePostClosure: ((Post) -> Void)?
    
    private var dataSourceCollection: UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>?
    
    // MARK: - Initializers
    
    init(with post: Post, delegate: DetailPostControllerDelegate?){
        super.init(nibName: nil, bundle: nil)
        currentPost = post
        self.delegate = delegate
        if let images = post.images {
            photos = images.prefix(4).map{ $0 }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupLayout()
        configureNavigationController()
        configureDataSourceCollection()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.postPhotosCollectionView.collectionViewLayout.invalidateLayout() // Чтобы перечитались constaints только у collectionView 
            self.applySnapshotCollection(with: self.photos, animated: false)
        }
    }
    
    // MARK: Setup Layout
    
    private func setupLayout() {
        contentView.addSubview(postStackView)
        contentView.addSubview(postDateLabel)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        postCollectionViewHeightConstraint = postPhotosCollectionView.heightAnchor.constraint(equalToConstant: photos.isEmpty ? 0 : 400)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            postDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacingConstant),
            postDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacingConstant),
    
            postStackView.topAnchor.constraint(equalTo: postDateLabel.bottomAnchor, constant: 20),
            postStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacingConstant),
            postStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacingConstant),
            postStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacingConstant),
            
            postCollectionViewHeightConstraint!
        ])
    }
    
    // MARK: Configure NavigationController
  
    private func configureNavigationController() {
        let deletePostButton = UIBarButtonItem(systemItem: .trash, primaryAction: deletePostAction, menu: nil)
        deletePostButton.tintColor = .systemRed
        let editButton = UIBarButtonItem(title: "Edit", primaryAction: editPostAction, menu: nil)
        navigationItem.rightBarButtonItems = [deletePostButton,editButton]
    }
    
    // MARK: Configure Collection DataSource
    
    private func configureDataSourceCollection() {
        dataSourceCollection = UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>(collectionView: postPhotosCollectionView, cellProvider: { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.configureCell(with: image, isEdit: false)
            return cell
        })
        applySnapshotCollection(with: photos, animated: true)
    }
    
    private func applySnapshotCollection(with photos: [UIImage], animated: Bool) {
        postCollectionViewHeightConstraint?.constant = photos.isEmpty ? 0 : 400
        view.layoutIfNeeded() // Чтобы без задержок выстроились constraints
        var snashot = NSDiffableDataSourceSnapshot<SectionCollectionCell, UIImage>()
        snashot.appendSections([.main])
        snashot.appendItems(photos)
        dataSourceCollection?.apply(snashot, animatingDifferences: animated)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension DetailPostViewController: UICollectionViewDelegateFlowLayout{
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wight = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        switch photos.count {
        case 1:
            return CGSize(width: wight, height: height)
        case 2:
            return CGSize(width: wight/2, height: height)
        case 3:
            if indexPath.item == 2{
                return CGSize(width: wight, height: height/2)
            } else {
                return CGSize(width: wight/2, height: height/2)
            }
        case 4:
            return CGSize(width: wight/2, height: height/2)
        default:
            return CGSize(width: wight, height: height)
        }
        
    }
    
}

