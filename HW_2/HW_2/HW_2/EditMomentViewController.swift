//
//  EditMomentViewController.swift
//  HW_2
//
//  Created by Павел Калинин on 20.10.2024.
//


import UIKit

class EditMomentViewController: UIViewController {
    
    private var images: [UIImage] = [] {
        didSet {
            if images.count > maxImagesCount {
                images = Array(images.prefix(maxImagesCount))
            }
        }
    }
    private let maxImagesCount = 4
    private var moment: Moment?
    var completion: ((Moment)->Void)?
    
    init(moment: Moment? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.moment = moment
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var photoLabel: UILabel = {
        var label = UILabel()
        label.text = "Фото"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descrLabel: UILabel = {
        var label = UILabel()
        label.text = "Описание"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var descrTextView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 2
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        view.addSubview(photoLabel)
        view.addSubview(collectionView)
        view.addSubview(descrLabel)
        view.addSubview(descrTextView)
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let closeAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        let saveAction = UIAction {[weak self] _ in
            guard let self = self else { return }
            if !images.isEmpty || !descrTextView.text.isEmpty {
                let moment = Moment(id: moment?.id ?? UUID(), date: moment?.date ?? Date(), images: self.images, description: self.descrTextView.text ?? "")
                self.completion?(moment)
            } else {
                let alert = UIAlertController(title: "Момент не может быть пустым", message: "Пожалуйста, выберите фото или введите текст", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                self.present(alert, animated: true)
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", primaryAction: closeAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", primaryAction: saveAction)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            photoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 130),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            descrLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            descrLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            descrTextView.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 10),
            descrTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descrTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            descrTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func configure() {
        if let moment = moment {
            self.images = moment.images
            descrTextView.text = moment.description
        }
    }
}

extension EditMomentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count < maxImagesCount ? images.count + 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        
        if indexPath.item < images.count {
            cell.configure(with: images[indexPath.item], isAddButton: false)
            cell.onDelete = { [weak self] in
                self?.images.remove(at: indexPath.item)
                collectionView.reloadData()
            }
        } else {
            cell.configure(with: nil, isAddButton: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count {
            openImagePicker()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

extension EditMomentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openImagePicker() {
        guard images.count < maxImagesCount else { return }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            images.append(selectedImage)
            collectionView.reloadData()
        }
    }
}
