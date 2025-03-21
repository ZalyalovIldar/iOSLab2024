//
//  CreateViewController.swift
//  MyMoment
//
//  Created by Павел on 21.10.2024.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    private let constraintConstant: CGFloat = 10
    private var photos: [UIImage] = []
    private var addButton: UIButton?
    private let maxPhoto = 4
    var exisitingPost: Post?
    var newPostClosure: ((Post) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
        configure()
    }
    
    // MARK: - UI Elements

    private lazy var photoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collection.layer.cornerRadius = 5
        
        return collection
    }()
    
    private lazy var titleLabel: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название (необязательно)"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.textAlignment = .natural
        return textField
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .natural
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()


    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(photoTitleLabel)
        view.addSubview(imageCollectionView)
        view.addSubview(descriptionTitleLabel)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constraintConstant),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant),
            
            photoTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: constraintConstant * 2),
            photoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant),
            
            imageCollectionView.topAnchor.constraint(equalTo: photoTitleLabel.bottomAnchor, constant: constraintConstant * 2),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: constraintConstant),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant),
            
            textView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: constraintConstant * 2),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constraintConstant)
        ])
    }

    // MARK: - Navigation Bar Setup

    private func setupNavigationBar() {
        let savePost = UIAction { [weak self] _ in
            guard let self else { return }
            let postText = self.textView.text ?? ""
            let postTitle = self.titleLabel.text ?? ""

            if !self.textView.text.isEmpty || !self.photos.isEmpty {
                let postID = self.exisitingPost?.id ?? UUID()
                let newPost = Post(id: postID,title: postTitle, date: Date(), text: postText, photos: self.photos)
                print("self.photos\(self.photos), photos\(photos)")
                self.newPostClosure?(newPost)
                self.dismiss(animated: true)
            } else {
                let alertAction = UIAlertAction(title: "Хорошо", style: .default)
                let alert = UIAlertController(title: "Пост не может быть пустым", message: "Добавьте фото или напишите что-то", preferredStyle: .alert)
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        }

        let cancelPost = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        self.title = exisitingPost == nil ? "Новый пост" : "Редактирование поста"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), primaryAction: savePost)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.bin"), primaryAction: cancelPost)
    }
    
    // MARK: - Configuration
    
    private func configure() {
        guard let post = exisitingPost else { return }
        self.titleLabel.text = post.title
        self.photos = post.photos
        self.textView.text = post.text
        imageCollectionView.reloadData()
    }
    
    // MARK: - UIImagePickerController Delegate Methods

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }

        if photos.count < maxPhoto {
            photos.append(image)
            imageCollectionView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc private func addPhoto() {
        if photos.count < maxPhoto {
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
              let indexPath = imageCollectionView.indexPath(for: cell) else {
            return
        }
        photos.remove(at: indexPath.item)
        imageCollectionView.reloadData()
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count < maxPhoto ? photos.count + 1 : photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }

        if indexPath.item == photos.count && photos.count < maxPhoto {
            cell.setupAddPhotoButton()
            cell.addButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        } else {
            cell.configureCell(with: photos[indexPath.item])
            cell.deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        }
        return cell
    }
}
