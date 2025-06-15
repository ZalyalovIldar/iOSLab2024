//
//  PostEditDetailViewController.swift
//  homework2
//
//  Created by Ильнур Салахов on 28.11.2024.
//

import UIKit

protocol EditPostDelegate: AnyObject {
    func didUpdatePost(_ post: Post, at index: Int)
    func didDeletePost(at index: Int)
}

class EditPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: EditPostDelegate?
    var postToEdit: Post!
    var postIndex: Int!
    
    private let textView = UITextView()
    private var photoCollectionView: UICollectionView!
    private var selectedImages = [UIImage?]()
    private let maxImages = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        selectedImages = postToEdit.images
        setupNavigationBar()
        setupTextView()
        setupPhotoCollectionView()
    }
    
    private func setupNavigationBar() {
        title = "Редактировать пост"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(savePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelEdit))
        
        let deleteAction = UIBarButtonItem(title: "Удалить", style: .done, target: self, action: #selector(deletePost))
        navigationItem.setRightBarButtonItems([deleteAction, navigationItem.rightBarButtonItem!], animated: false)
    }
    
    private func setupTextView() {
        textView.text = postToEdit.text
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupPhotoCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoCollectionView)
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func savePost() {
        postToEdit.text = textView.text
        postToEdit.images = selectedImages
        postToEdit.date = Date()
        delegate?.didUpdatePost(postToEdit, at: postIndex)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func cancelEdit() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func deletePost() {
        let alert = UIAlertController(title: "Удалить пост?", message: "Вы уверены, что хотите удалить этот пост?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            self.delegate?.didDeletePost(at: self.postIndex)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count < maxImages ? selectedImages.count + 1 : maxImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        if indexPath.item < selectedImages.count {
            cell.configure(with: selectedImages[indexPath.item]!)
            cell.onDelete = { [weak self] in
                self?.selectedImages.remove(at: indexPath.item)
                collectionView.reloadData()
            }
        } else {
            cell.configureAsAddButton()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedImages.count {
            if selectedImages.count < maxImages {
                openImagePicker()
            }
        }
    }
    
    private func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
            photoCollectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

