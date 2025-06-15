//
//  DetailViewController.swift
//  HW_2
//
//  Created by Damir Rakhmatullin on 15.11.24.
//

import UIKit

protocol DetailPostControllerDelegate: AnyObject {
    func deletePost(with: Post)
}

class DetailViewController: UIViewController {
    
    enum SectionCollectionCell {
            case main
    }

    private let spacingConstant: CGFloat = 10
    
    private var photos: [UIImage] = [UIImage]()
    
    private var currentPost: Post!
    
    private var dataSourceCollection: UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>?
    
    private weak var delegate: DetailPostControllerDelegate?
    
    private var postCollectionViewHeightConstraint: NSLayoutConstraint?
    
    var updatePostClosure: ((Post) -> Void)?
    
   
        
    
    private let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d yyyy"
        return formatter
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with post: Post, delegate: DetailPostControllerDelegate?){
        super.init(nibName: nil, bundle: nil)
        currentPost = post
        titleTextView.text = post.title
        text.text = post.text
        titleTextView.isEditable = false
        text.isEditable = false
        dateLabel.text = dateFormater.string(from: post.date)
        self.delegate = delegate
        photos = post.images ?? []
    }
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var titleTextView: UITextView = {
        let title = UITextView()
        title.font = UIFont.systemFont(ofSize: 20)
        title.isScrollEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    private lazy var text: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 16)
        text.isScrollEnabled = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var dateLabel: UILabel = {
           let label = UILabel()
           label.text = dateFormater.string(from: currentPost.date)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
    }()
    
    private lazy var postPhotosCollectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.sectionInset = .zero
           layout.scrollDirection = .horizontal
        
        
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.translatesAutoresizingMaskIntoConstraints = false
           collectionView.isScrollEnabled = true
           collectionView.delegate = self
           collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
           return collectionView
       }()
    
    private lazy var deletePostAction: UIAction = UIAction { _ in
          let allert = UIAlertController(title: "Вы уверены удалить?", message: nil, preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
          let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { UIAlertAction in
              self.delegate?.deletePost(with: self.currentPost)
              self.navigationController?.popViewController(animated: true)
          }
          allert.addAction(cancelAction)
          allert.addAction(deleteAction)
          self.present(allert, animated: true)
    }
    
    private lazy var editPostAction: UIAction = UIAction { _ in
        let editVC = PostViewController(post: self.currentPost)
        editVC.savePostClosure = { [weak self] updatedPost in
            guard let self = self else { return }
            
            self.currentPost = updatedPost
            text.text = currentPost.text
            titleTextView.text = currentPost.title
            if let images = currentPost.images {
                photos = images
                applySnapshotCollection(with: photos, animated: false)
            }
            self.updatePostClosure?(updatedPost)
            self.dismiss(animated: true)
        }
        
        let edinNVS = UINavigationController(rootViewController: editVC)
        edinNVS.modalPresentationStyle = .fullScreen
        self.present(edinNVS, animated: true)
    }
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            postPhotosCollectionView,
            titleTextView,
            text,
            dateLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private func applySnapshotCollection(with photos: [UIImage], animated: Bool) {
        postCollectionViewHeightConstraint?.constant = photos.isEmpty ? 0 : 400
        var snapshot = NSDiffableDataSourceSnapshot<SectionCollectionCell, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSourceCollection?.apply(snapshot, animatingDifferences: animated)
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        scrollView.addSubview(verticalStackView)
        view.addSubview(scrollView)
    
        postCollectionViewHeightConstraint = postPhotosCollectionView.heightAnchor.constraint(equalToConstant: photos.isEmpty ? 0 : 400)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postCollectionViewHeightConstraint!

        ])
    }
    
    private func configureDataSourceCollection() {
            dataSourceCollection = UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>(collectionView: postPhotosCollectionView, cellProvider: { collectionView, indexPath, image in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
                cell.configureCell(with: image, isEdit: true)
                return cell
            })
            applySnapshotCollection(with: photos, animated: true)
    }
    
    func configureNavigationController() {
        let deletePostButton = UIBarButtonItem(systemItem: .trash, primaryAction: deletePostAction, menu: nil)
        deletePostButton.tintColor = .systemRed
        let editButton = UIBarButtonItem(title: "Изменить", primaryAction: editPostAction, menu: nil)
        navigationItem.rightBarButtonItems = [deletePostButton, editButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureDataSourceCollection()
        configureNavigationController()
    }
    
    
}
extension DetailViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        
        switch photos.count {
            case 1:
                return CGSize(width: view.frame.width, height: 200)
            case 2:
                return CGSize(width: screenWidth / 2, height: screenWidth / 2)
            case 3:
                return CGSize(width: screenWidth / 2, height: screenWidth / 2)
            default:
                return CGSize(width: screenWidth / 3, height: screenWidth / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}
