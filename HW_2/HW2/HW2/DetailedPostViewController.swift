//
//  DetailedPostViewController.swift
//  HW2
//
//  Created by Терёхин Иван on 25.10.2024.
//

import UIKit

protocol DetailPostControllerDelegate: AnyObject {
    func deletePost(with post: Post)
    func updatePost(with post: Post)
}

class DetailedPostViewController: UIViewController {
    
    
    private var post: Post!
    private var images: [UIImage] = []
    weak var delegate: DetailPostControllerDelegate?
    private var update: ((Post) -> Void)?
    
    private let topAndBottomConstraint: CGFloat = 8
    private let leadingConstraint: CGFloat = 16
    private let trailingConstraint: CGFloat = -16
    private let heightSize: CGFloat = 200
    private let photoHeightForOneAndTwo: CGFloat = 200
    private let photoHeightForThree: CGFloat = 400
    private let minimumLineSpacingFromCollectionView: CGFloat = 5
    private let stackSpacing: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        
    }
    
    init(delegate: DetailPostControllerDelegate, post: Post) {
        self.post = post
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        text.text = self.post.text
        navigationItem.title = self.post.title
        setupaLayout()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        
        let editAction = UIAction { _ in
            let createVc = CreatePostsViewController(post: self.post)
            createVc.post = self.post
            createVc.completion = { [ weak self ] updatePost in
                guard let self = self else { return }
                self.post = updatePost
                self.configure()
                self.photo.reloadData()
                self.delegate?.updatePost(with: post)
                
    
            }
            let navVC = UINavigationController(rootViewController: createVc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let deleteAction = UIAction {[ weak self ] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Предупреждение", message: "Вы точно хотитие удалить момент?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.delegate?.deletePost(with: self.post)
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(systemItem: .edit, primaryAction: editAction, menu: nil),
            UIBarButtonItem(systemItem: .trash, primaryAction: deleteAction, menu: nil)
        ]
                                             
    }
   
    
    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var text: UILabel = {
        
        let text = UILabel()
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var postTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [text, photo])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = stackSpacing
        return stack
    }()
    
    private lazy var photo: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacingFromCollectionView
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        return collectionView
    }()
    
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
    }
    
    private func setupPhotoHeight() -> CGFloat {
        let photoHeight: CGFloat
        switch post.photos.count {
        case 1:
            photoHeight = photoHeightForOneAndTwo
        case 2:
            photoHeight = photoHeightForOneAndTwo
        case 3:
            photoHeight = photoHeightForThree
        default:
            let rows = CGFloat((post.photos.count + 2) / 3)
            photoHeight = rows * 120 + (rows - 1) * 10
        }
        return photoHeight
    }
    
    private func setupaLayout() {
        
        view.addSubview(scroll)
        scroll.addSubview(stack)
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAndBottomConstraint),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstraint),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: topAndBottomConstraint),
            
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            
            photo.heightAnchor.constraint(equalToConstant: setupPhotoHeight())
        ])
        
    }
    private func configure() {
        guard let post = post else { return }
        text.text = post.text
        navigationItem.title = post.title
        images = post.photos
    
    }
}
extension DetailedPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        cell.configure(with: post.photos[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsCount = post.photos.count
        let width = collectionView.bounds.width
        switch itemsCount {
        case 1:
            return CGSize(width: width, height: heightSize)
            
        case 2:
            let width = (width - 10) / 2
            return CGSize(width: width, height: width)
            
        case 3:
            if indexPath.item == 2 {
                return CGSize(width: width, height: heightSize)
            } else {
                let width = (width - 10) / 2
                return CGSize(width: width, height: width)
            }
            
        default:
            let width = (width - 20) / 3
            return CGSize(width: width, height: width)
        }
    }
}




    

