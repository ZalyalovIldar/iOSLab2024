//
//  EditPostViewController.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 29.10.2024.
//

import UIKit

final class EditPostViewController: UIViewController {
    var post: Post?
    var completion: ((Post) -> Void)?
    private var images: [UIImage] = []

    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AddImageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        view.backgroundColor = .white
        if let post = post {
            textView.text = post.text
            images = post.images ?? []
        }
    }

    private func setupNavigationBar() {
        title = post == nil ? "Создать пост" : "Редактировать пост"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(savePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancel))
    }

    private func setupViews() {
        view.addSubview(textView)
        view.addSubview(imagesCollectionView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 100),

            imagesCollectionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func savePost() {
        
        if textView.text.isEmpty && images.isEmpty {
            let alert = UIAlertController(title: "Ошибка", message: "Пост должен содержать текст или изображения.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            return
        }

        let newPost = Post(id: post?.id ?? UUID(), date: Date(), text: textView.text.isEmpty ? nil : textView.text, images: images.isEmpty ? nil : images)
        completion?(newPost)
        navigationController?.popViewController(animated: true)
    }

    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }

    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension EditPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count < 4 ? images.count + 1 : images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == images.count && images.count < 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath)
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            let plusLabel = UILabel()
            plusLabel.text = "+"
            plusLabel.font = UIFont.systemFont(ofSize: 40)
            plusLabel.textAlignment = .center
            plusLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(plusLabel)
            NSLayoutConstraint.activate([
                plusLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                plusLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: images[indexPath.item])
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count && images.count < 4 {
            presentImagePicker()
        } else {
            let fullImageVC = FullImageViewController()
            fullImageVC.image = images[indexPath.item]
            navigationController?.pushViewController(fullImageVC, animated: true)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func didTapDeleteButton(in cell: ImageCollectionViewCell) {
        if let indexPath = imagesCollectionView.indexPath(for: cell) {
            images.remove(at: indexPath.item)
            imagesCollectionView.deleteItems(at: [indexPath])
        }
    }
}

extension EditPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            images.append(image)
            imagesCollectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
