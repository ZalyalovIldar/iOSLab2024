//
//  CreatePostsViewController.swift
//  HW2
//
//  Created by Терёхин Иван on 27.10.2024.
//

import UIKit

class CreatePostsViewController: UIViewController{
    
    private var images: [UIImage] = []
    var post: Post!
    let maxCntImage = 4
    var completion: ((Post) -> Void)?
    
    private let cornerRadiusTextView: CGFloat = 10
    private let borderWidthTextView: CGFloat = 0.5
    private let leadingConstant: CGFloat = 16
    private let trailingConstant: CGFloat = -16
    private let topConstantPhotos: CGFloat = 20
    private let topConstant: CGFloat = 15
    private let titlePostHeightConstant: CGFloat = 50
    private let textPostHeightConstant: CGFloat = 150
    private let itemSizePhotosConstant: CGFloat = 100
    private let textSizeForHeadings: CGFloat = 17
    private let textSize: CGFloat = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupNavigationBar()
        
    }
    
    init(post: Post? = nil) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textLabel: UILabel = {
        
        let text = UILabel()
        text.text = "Описание"
        text.font = UIFont.systemFont(ofSize: textSizeForHeadings, weight: .medium)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Заголовок"
        title.font = UIFont.systemFont(ofSize: textSizeForHeadings, weight: .medium)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
        
    }()
    
    private lazy var photoLabel: UILabel = {
        let photoText = UILabel()
        photoText.text = "Фото"
        photoText.textAlignment = .center
        photoText.font = UIFont.systemFont(ofSize: textSizeForHeadings, weight: .medium)
        photoText.translatesAutoresizingMaskIntoConstraints = false
        
        return photoText
    }()
    
    
    private lazy var textPost: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: textSize)
        text.layer.cornerRadius = cornerRadiusTextView
        text.layer.borderColor = UIColor.gray.cgColor
        text.layer.borderWidth = borderWidthTextView
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    private lazy var titlePost: UITextView = {
        let title = UITextView()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: textSizeForHeadings)
        title.textColor = .black
        title.layer.cornerRadius = cornerRadiusTextView
        title.layer.borderColor = UIColor.gray.cgColor
        title.layer.borderWidth = borderWidthTextView
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
    private lazy var photos: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSizePhotosConstant, height: itemSizePhotosConstant)
        
        let image = UICollectionView(frame: .zero, collectionViewLayout: layout)
        image.delegate = self
        image.dataSource = self
        image.translatesAutoresizingMaskIntoConstraints = false
        image.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        return image
    }()
    
    
    private func setupNavigationBar() {
        navigationItem.title = "Новая заметка"
        let saveAction = UIAction { [ weak self ] _ in
            guard let self = self else { return }
            if !images.isEmpty  || (textPost.hasText && titlePost.hasText) {
                let post = Post(id: post?.id ?? UUID(),
                                title: self.titlePost.text ?? "",
                                text: self.textPost.text ?? "",
                                data: post?.data ?? Date(),
                                photos: self.images)
                self.completion?(post)
                self.dismiss(animated: true)
                
            } else {
                let alert = UIAlertController(title: "Предупреждение",
                                              message: "Задайте текст и заголовок" ,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                self.present(alert, animated: true)
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Сохранить", image: nil, primaryAction: saveAction, menu: nil)
        
        let canselAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", image: nil, primaryAction: canselAction, menu: nil)
    }
    
    private func setupLayout() {
        view.addSubview(scroll)
        scroll.addSubview(titleLabel)
        scroll.addSubview(titlePost)
        scroll.addSubview(textLabel)
        scroll.addSubview(textPost)
        scroll.addSubview(photoLabel)
        scroll.addSubview(photos)
        
        
        NSLayoutConstraint.activate([
            
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scroll.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            
            titlePost.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topConstant),
            titlePost.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            titlePost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            titlePost.heightAnchor.constraint(equalToConstant: titlePostHeightConstant),
            
            textLabel.topAnchor.constraint(equalTo: titlePost.bottomAnchor, constant: topConstant),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            
            textPost.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: topConstant),
            textPost.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            textPost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            textPost.heightAnchor.constraint(equalToConstant: textPostHeightConstant),
            
            photoLabel.topAnchor.constraint(equalTo: textPost.bottomAnchor, constant: topConstant),
            photoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            photoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            
            photos.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: topConstantPhotos),
            photos.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            photos.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant),
            photos.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func configure() {
        if let post = post {
            images = post.photos
            titlePost.text = post.title
            textPost.text = post.text
            photos.reloadData()
        }
    }
    @objc private func addPhoto() {
        if images.count < maxCntImage {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
           } else {
               return
           }
       }

       @objc private func deletePhoto(_ sender: UIButton) {
           guard let cell = sender.superview?.superview as? PhotoCell,
                 let indexPath = photos.indexPath(for: cell) else {
                    return
           }
           images.remove(at: indexPath.item)
           photos.reloadData()
       }
}
    

extension CreatePostsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count < maxCntImage ? images.count + 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photos.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        if indexPath.item == images.count && images.count < maxCntImage {
            cell.setupAddPhotoButton()
            cell.addButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        } else {
            cell.configureForEdit(with: images[indexPath.item])
            cell.deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        }
        return cell
    }
}
extension CreatePostsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        if images.count < maxCntImage {
            images.append(image)
            photos.reloadData()
            picker.dismiss(animated: true)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

