//
//  CreatePostViewController.swift
//  hw_2
//
//  Created by Кирилл Титов on 21.11.2024.
//

import UIKit

final class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var onPostCreated: ((Post) -> Void)? 
    private var post: Post?
    private var images: [UIImage] = []

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить фото", for: .normal)
        button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(post: Post? = nil) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        if let post = post {
            self.images = post.images
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let post = post {
            configureForEditing(post)
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = post == nil ? "Новый пост" : "Редактировать пост"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePost))

        view.addSubview(textView)
        view.addSubview(collectionView)
        view.addSubview(addImageButton)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 100),

            collectionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 80),

            addImageButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureForEditing(_ post: Post) {
        textView.text = post.text
        collectionView.reloadData()
    }

    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func savePost() {
        guard let text = textView.text, !text.isEmpty || !images.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Пост должен содержать текст или хотя бы одно изображение.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if var currentPost = post {
            currentPost.text = text
            currentPost.images = images
            onPostCreated?(currentPost)
        } else {
            let newPost = Post(date: Date(), text: text, images: images)
            onPostCreated?(newPost)
        }
        
        dismiss(animated: true, completion: nil)
    }

    @objc private func selectImage() {
        guard images.count < 4 else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            images.append(image)
            collectionView.reloadData()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreatePostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.image = images[indexPath.item]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        return cell
    }
}
