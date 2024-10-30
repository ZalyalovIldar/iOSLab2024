//
//  EditPostViewController.swift
//  HW_2a
//
//  Created by Артур Мавликаев on 29.10.2024.
//

import UIKit

protocol EditPostDelegate: AnyObject {
    func didUpdatePost(_ post: Post, at index: Int?)
}

class EditPostViewController: UIViewController {
    var post: Post?
    var index: Int?
    weak var delegate: EditPostDelegate?
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
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
            images = post.images
        }
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(savePost)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        ]
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
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 300),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func savePost() {
        let newPost = Post(id: UUID(), date: Date(), text: textView.text, images: images)
        delegate?.didUpdatePost(newPost, at: index)
        navigationController?.popViewController(animated: true)
    }

    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImage() {
        if images.count <= 3 {
            presentImagePicker()
        } else {
            let alertController = UIAlertController(title: "Максимальное количество изображений",
                                                    message: "Вы можете добавить не более четырех изображений.",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension EditPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.configure(with: images[indexPath.item])

        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPressGesture)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullImageVC = FullImageViewController()
        fullImageVC.image = images[indexPath.item]
        navigationController?.pushViewController(fullImageVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch images.count {
        case 1:
            return CGSize(width: width, height: width)
        case 2:
            return CGSize(width: width / 2 - 5, height: width / 2)
        case 3:
            return indexPath.item == 2 ? CGSize(width: width, height: width / 2) : CGSize(width: width / 2 - 5, height: width / 2)
        default:
            return CGSize(width: width / 2 - 5, height: width / 2)
        }
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let cell = gesture.view as? UICollectionViewCell,
              let indexPath = imagesCollectionView.indexPath(for: cell) else { return }
        images.remove(at: indexPath.item)
        imagesCollectionView.deleteItems(at: [indexPath])
    }
}

extension EditPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
