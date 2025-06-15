//
//  PostDetailViewController.swift
//  hw_2
//
//  Created by Кирилл Титов on 21.11.2024.
//

import UIKit

final class PostDetailViewController: UIViewController {

    private var post: Post
    var onPostUpdated: ((Post) -> Void)?
    var onPostDeleted: ((Post) -> Void)?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let imagesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure(with: post)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editPost)),
            UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deletePost))
        ]
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editPost))

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(dateLabel)
        contentView.addSubview(textView)
        contentView.addSubview(imagesContainerView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            imagesContainerView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            imagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imagesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagesContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imagesContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }

    private func configure(with post: Post) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: post.date)
        textView.text = post.text

        imagesContainerView.subviews.forEach { $0.removeFromSuperview() }

        let imageViews = post.images.map { image -> UIImageView in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }

        if imageViews.count == 1 {
            let imageView = imageViews[0]
            imagesContainerView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: imagesContainerView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                imageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: imagesContainerView.widthAnchor),
                imageView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor)
            ])
        } else if imageViews.count == 2 {
            let leftImageView = imageViews[0]
            let rightImageView = imageViews[1]
            imagesContainerView.addSubview(leftImageView)
            imagesContainerView.addSubview(rightImageView)

            NSLayoutConstraint.activate([
                leftImageView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
                leftImageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                leftImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                leftImageView.heightAnchor.constraint(equalTo: leftImageView.widthAnchor),
                leftImageView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor),

                rightImageView.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
                rightImageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                rightImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                rightImageView.heightAnchor.constraint(equalTo: rightImageView.widthAnchor),
                rightImageView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor)
            ])
        } else if imageViews.count == 3 {
            let topLeftImageView = imageViews[0]
            let topRightImageView = imageViews[1]
            let bottomImageView = imageViews[2]

            imagesContainerView.addSubview(topLeftImageView)
            imagesContainerView.addSubview(topRightImageView)
            imagesContainerView.addSubview(bottomImageView)

            NSLayoutConstraint.activate([
                topLeftImageView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
                topLeftImageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                topLeftImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                topLeftImageView.heightAnchor.constraint(equalTo: topLeftImageView.widthAnchor),

                topRightImageView.leadingAnchor.constraint(equalTo: topLeftImageView.trailingAnchor, constant: 8),
                topRightImageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                topRightImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                topRightImageView.heightAnchor.constraint(equalTo: topRightImageView.widthAnchor),

                bottomImageView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
                bottomImageView.topAnchor.constraint(equalTo: topLeftImageView.bottomAnchor, constant: 8),
                bottomImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor),
                bottomImageView.heightAnchor.constraint(equalTo: bottomImageView.widthAnchor),
                bottomImageView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor)
            ])
        } else if imageViews.count >= 4 {
            let topLeftImageView = imageViews[0]
            let topRightImageView = imageViews[1]
            let bottomLeftImageView = imageViews[2]
            let bottomRightImageView = imageViews[3]

            imagesContainerView.addSubview(topLeftImageView)
            imagesContainerView.addSubview(topRightImageView)
            imagesContainerView.addSubview(bottomLeftImageView)
            imagesContainerView.addSubview(bottomRightImageView)

            NSLayoutConstraint.activate([
                topLeftImageView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
                topLeftImageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                topLeftImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                topLeftImageView.heightAnchor.constraint(equalTo: topLeftImageView.widthAnchor),

                topRightImageView.leadingAnchor.constraint(equalTo: topLeftImageView.trailingAnchor, constant: 8),
                topRightImageView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
                topRightImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                topRightImageView.heightAnchor.constraint(equalTo: topRightImageView.widthAnchor),

                bottomLeftImageView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
                bottomLeftImageView.topAnchor.constraint(equalTo: topLeftImageView.bottomAnchor, constant: 8),
                bottomLeftImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                bottomLeftImageView.heightAnchor.constraint(equalTo: bottomLeftImageView.widthAnchor),
                bottomLeftImageView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor),

                bottomRightImageView.leadingAnchor.constraint(equalTo: bottomLeftImageView.trailingAnchor, constant: 8),
                bottomRightImageView.topAnchor.constraint(equalTo: topRightImageView.bottomAnchor, constant: 8),
                bottomRightImageView.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor, multiplier: 0.5, constant: -4),
                bottomRightImageView.heightAnchor.constraint(equalTo: bottomRightImageView.widthAnchor),
                bottomRightImageView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor)
            ])
        }
    }

        
    @objc private func deletePost() {
        let alertController = UIAlertController(title: "Удалить пост", message: "Вы уверены, что хотите удалить этот пост?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.onPostDeleted?(self.post)
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alertController, animated: true, completion: nil)
    }

    @objc private func editPost() {
        let editVC = CreatePostViewController(post: post)
        editVC.onPostCreated = { [weak self] updatedPost in
            guard let self = self else { return }
            self.post = updatedPost
            self.configure(with: updatedPost)
            self.onPostUpdated?(updatedPost)
            self.navigationController?.popViewController(animated: true)
        }
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

