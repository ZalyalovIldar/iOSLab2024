//
//  DetailViewController.swift
//  MyMoment
//
//  Created by Павел on 23.10.2024.
//

import UIKit

// MARK: - Protocols

protocol DetailPostDelegate: AnyObject {
    func updatePost(post: Post)
    func deletePost(post: Post)
}

// MARK: - DetailViewController

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var photos: [UIImage] = []
    var post: Post?
    weak var delegate: DetailPostDelegate?
    private var titleString: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureView()
        updateHeightImageCollection()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), primaryAction: editAction),
            UIBarButtonItem(image: UIImage(systemName: "trash"), primaryAction: deleteAction)
        ]
        navigationItem.title = "\(titleString)"
    }
    private func setupUI() {
        let constraintConstant: CGFloat = 10
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: constraintConstant),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: constraintConstant),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -constraintConstant),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -constraintConstant),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * constraintConstant),
            
            imageCollectionView.topAnchor.constraint(equalTo: stackView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            descriptionStack.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: constraintConstant),
            descriptionStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            descriptionStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            descriptionStack.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    private lazy var editAction = UIAction { [weak self] _ in
        guard let self = self, let post = self.post else { return }
        let createViewController = CreateViewController()
        createViewController.exisitingPost = post
        createViewController.newPostClosure = { [weak self] newPost in
            guard let self else { return }
            self.post = newPost
            self.configureView()
            self.imageCollectionView.reloadData()
            self.updateHeightImageCollection()
            
            self.delegate?.updatePost(post: newPost)
        }
        
        createViewController.modalPresentationStyle = .formSheet
        let navigationController = UINavigationController(rootViewController: createViewController)
        self.present(navigationController, animated: true)
    }
    
    private lazy var deleteAction = UIAction { [weak self] _ in
        guard let self = self, let post = self.post else { return }
        
        let deleteAlertAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.deletePost(post: post)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel)
        let alert = UIAlertController(title: "Удаление поста", message:
                                        "Вы действительно хотите удалить  \(titleString.isEmpty ? "пост" : titleString)?",
                                      preferredStyle: .alert)
        alert.addAction(deleteAlertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - Views
    
   private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
       scroll.addSubview(stackView)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            imageCollectionView, descriptionStack
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
   private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.isScrollEnabled = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(DetailPhotoCell.self, forCellWithReuseIdentifier: DetailPhotoCell.identifier)
        collection.layer.cornerRadius = 5
        return collection
    }()
    
   private lazy var descriptionStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [descriptionLabel, dateLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    // MARK: - Helpers
    
    private func configureView() {
        guard let postData = post else { return }
        photos = postData.photos
        dateLabel.text = postData.date.formatted(date: .complete, time: .shortened)
        descriptionLabel.text = postData.text
        titleString = postData.title
    }
    
    private func updateHeightImageCollection() {
        if photos.isEmpty {
            imageCollectionView.isHidden = true
        } else if photos.count < 3 {
            imageCollectionView.isHidden = false
            imageCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        } else {
            imageCollectionView.isHidden = false
            imageCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCell.identifier, for: indexPath) as! DetailPhotoCell
        cell.configureCell(with: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch photos.count {
        case 1:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        case 2:
            return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height)
        case 3:
            if indexPath.item < 2 {
                return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
            } else {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 2)
            }
        case 4:
            return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
        default:
            imageCollectionView.isHidden = true
            return CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.height / 3)
        }
    }
}
