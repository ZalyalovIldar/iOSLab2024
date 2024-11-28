//
//  PostDetailViewController.swift
//  homework2
//
//  Created by Ильнур Салахов on 21.11.2024.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var post: Post!
    weak var delegate: CreatePostDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var imagesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupScrollView()
        populateData()
    }
    
    private func setupNavigationBar() {
        title = "Детали поста"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editPost))
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(imagesContainer)
        
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
            
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            imagesContainer.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            imagesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imagesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagesContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func populateData() {
        textView.text = post.text
        setupImages(images: post.images)
    }
    
    private func setupImages(images: [UIImage?]) {
        imagesContainer.subviews.forEach { $0.removeFromSuperview() }
        
        let imageViews: [UIImageView] = images.map {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
        
        let gridSpacing: CGFloat = 8
        
        switch images.count {
        case 1:
            let imageView = imageViews[0]
            imagesContainer.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imagesContainer.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: imagesContainer.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: imagesContainer.trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                imageView.bottomAnchor.constraint(equalTo: imagesContainer.bottomAnchor)
            ])
        case 2:
            for (index, imageView) in imageViews.enumerated() {
                imagesContainer.addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: imagesContainer.topAnchor),
                    imageView.widthAnchor.constraint(equalTo: imagesContainer.widthAnchor, multiplier: 0.5, constant: -gridSpacing / 2),
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                    imageView.leadingAnchor.constraint(equalTo: index == 0 ? imagesContainer.leadingAnchor : imageViews[index - 1].trailingAnchor, constant: gridSpacing),
                ])
            }
            imagesContainer.addConstraint(imageViews[1].trailingAnchor.constraint(equalTo: imagesContainer.trailingAnchor))
        case 3:
            let topRow = [imageViews[0], imageViews[1]]
            for (index, imageView) in topRow.enumerated() {
                imagesContainer.addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: imagesContainer.topAnchor),
                    imageView.widthAnchor.constraint(equalTo: imagesContainer.widthAnchor, multiplier: 0.5, constant: -gridSpacing / 2),
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                    imageView.leadingAnchor.constraint(equalTo: index == 0 ? imagesContainer.leadingAnchor : topRow[index - 1].trailingAnchor, constant: gridSpacing)
                ])
            }
            imagesContainer.addConstraint(topRow[1].trailingAnchor.constraint(equalTo: imagesContainer.trailingAnchor))
            
            let bottomImage = imageViews[2]
            imagesContainer.addSubview(bottomImage)
            NSLayoutConstraint.activate([
                bottomImage.topAnchor.constraint(equalTo: topRow[0].bottomAnchor, constant: gridSpacing),
                bottomImage.leadingAnchor.constraint(equalTo: imagesContainer.leadingAnchor),
                bottomImage.trailingAnchor.constraint(equalTo: imagesContainer.trailingAnchor),
                bottomImage.heightAnchor.constraint(equalTo: topRow[0].heightAnchor),
                bottomImage.bottomAnchor.constraint(equalTo: imagesContainer.bottomAnchor)
            ])
        default:
            break
        }
    }
    
    @objc private func editPost() {
        let editVC = CreatePostViewController()
        editVC.postToEdit = post
        editVC.delegate = delegate
        editVC.textView.text = post.text
        editVC.selectedImages = post.images
        navigationController?.pushViewController(editVC, animated: true)
    }
}
