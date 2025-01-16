//
//  DetailPostViewController.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 29.10.2024.
//


import UIKit

final class DetailPostViewController: UIViewController {
    var post: Post?
    var updatePostClosure: ((Post) -> Void)?
    var deletePostClosure: (() -> Void)?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dateLabel = UILabel()
    private let textView = UITextView()
    private let imagesCollectionView: UICollectionView
    private var images: [UIImage] = []

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        self.imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        imagesCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupScrollView()
        setupViews()
        setupConstraints()
        updateUI()
        view.backgroundColor = .white
    }

    private func setupNavigationBar() {
        title = "Детали поста"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editPost)),
            UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deletePost))
        ]
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func setupViews() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(dateLabel)
        contentView.addSubview(textView)
        contentView.addSubview(imagesCollectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            
            imagesCollectionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func updateUI() {
        guard let post = post else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: post.date)
        textView.text = post.text
        images = post.images ?? []
        imagesCollectionView.reloadData()

        
        textView.sizeToFit()
        textView.layoutIfNeeded()

        
        updateImagesCollectionViewHeight()

        
        view.layoutIfNeeded()
    }

    private func updateImagesCollectionViewHeight() {
        
        imagesCollectionView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                imagesCollectionView.removeConstraint(constraint)
            }
        }

        
        imagesCollectionView.heightAnchor.constraint(equalToConstant: calculateImagesCollectionViewHeight()).isActive = true
    }

    @objc private func editPost() {
        let editVC = EditPostViewController()
        editVC.post = post
        editVC.completion = { [weak self] updatedPost in
            guard let self = self else { return }
            self.post = updatedPost
            self.updateUI()
            self.updatePostClosure?(updatedPost)
        }
        navigationController?.pushViewController(editVC, animated: true)
    }

    @objc private func deletePost() {
        let alert = UIAlertController(title: "Удалить пост", message: "Вы уверены, что хотите удалить этот пост?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.deletePostClosure?()
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    private func calculateImagesCollectionViewHeight() -> CGFloat {
        let width = view.frame.width
        switch images.count {
        case 0:
            return 0
        case 1:
            return width * 0.75
        case 2:
            let itemWidth = (width / 2) - 5
            return itemWidth * 1.2
        case 3:
            let itemWidth = (width / 2) - 5
            let firstRowHeight = itemWidth * 1.2
            let secondRowHeight = width * 0.5
            let totalSpacing: CGFloat = 10
            return firstRowHeight + secondRowHeight + totalSpacing
        default:
            let itemWidth = (width / 2) - 5
            let numberOfRows = ceil(Double(images.count) / 2.0)
            let rowHeight = itemWidth * 1.2
            let totalSpacing = CGFloat(numberOfRows - 1) * 10
            return CGFloat(numberOfRows) * rowHeight + totalSpacing
        }
    }
}

extension DetailPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.configure(with: images[indexPath.item])
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch images.count {
        case 1:
            return CGSize(width: width, height: width * 0.75)
        case 2:
            let itemWidth = (width / 2) - 5
            return CGSize(width: itemWidth, height: itemWidth * 1.2)
        case 3:
            if indexPath.item == 2 {
                return CGSize(width: width, height: width * 0.5)
            } else {
                let itemWidth = (width / 2) - 5
                return CGSize(width: itemWidth, height: itemWidth * 1.2)
            }
        default:
            let itemWidth = (width / 2) - 5
            return CGSize(width: itemWidth, height: itemWidth * 1.2)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullImageVC = FullImageViewController()
        fullImageVC.image = images[indexPath.item]
        navigationController?.pushViewController(fullImageVC, animated: true)
    }
}
