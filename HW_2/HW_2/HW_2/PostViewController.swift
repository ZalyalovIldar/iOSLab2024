//
//  PostViewController.swift
//  HW_2
//
//  Created by Damir Rakhmatullin on 20.11.24.
//

import UIKit

class PostViewController: UIViewController {
    
    private final var topSpaceConstant = CGFloat(20)
    private final let maxCountPhotos = 4
    private final let imageSizeConstant = CGFloat(60)
    private final let bottomSpaceConstant = CGFloat(10)
       
    var savePostClosure: ((Post) -> Void)?
    
    private lazy var titleTextView: UITextView = {
            let title = UITextView()
            title.text = "Заголовок"
            title.font = UIFont.systemFont(ofSize: 20)
            title.isScrollEnabled = false
            title.translatesAutoresizingMaskIntoConstraints = false
            
            return title
    }()
    
    private lazy var text: UITextView = {
           let text = UITextView()
            text.text = "Описание"
            text.textColor = .lightGray
            text.font = UIFont.systemFont(ofSize: 16)
            text.isScrollEnabled = false
            text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
        
    
    private lazy var verticalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                titleTextView,
                text,
            ])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 10
            stackView.axis = .vertical
            return stackView
    }()
    
    private lazy var addImageButton: UIButton = {
        var configureButton = UIButton.Configuration.plain()
        configureButton.baseBackgroundColor = .systemBlue
        let action = UIAction { [weak self] _ in
            self?.addPickerController()
        }
        let button = UIButton(configuration: configureButton, primaryAction: action)
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemGray6
        return button
    }()
        
    private lazy var saveNavigationBarButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            self?.saveData()
        }
        return UIBarButtonItem(title: "Сохранить", primaryAction: action)
    }()
    
    private lazy var cancelNavigationBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Отмена", primaryAction:  UIAction {[weak self] _ in
            self?.navigationController?.dismiss(animated: true)
        })
    }()
    
    private var collection: UICollectionView?
    private var photos: [UIImage] = []
    private var postDate: Date?
    
    private var currentPost: Post?
        

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        setupNavigationBar()
    }
    
    init(){
           super.init(nibName: nil, bundle: nil)
    }
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.currentPost = post
        self.titleTextView.text = post.title
        self.text.text = post.text
        self.postDate = post.date
        self.text.textColor = .black
        self.titleTextView.textColor = .black
        if let images = post.images {
            self.photos = images
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationBar() {
            navigationItem.rightBarButtonItem = saveNavigationBarButton
            navigationItem.leftBarButtonItem = cancelNavigationBarButton
     }
    
    private func addPickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        navigationController?.present(imagePickerController, animated: true)
    }
    
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        
        verticalStackView.insertArrangedSubview(collectionView, at: 0)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 100),
        ])

        collection = collectionView
    }
    
    private func setupLayout() {
        view.addSubview(verticalStackView)
        view.addSubview(addImageButton)
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo:  view.bottomAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: imageSizeConstant),

            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(bottomSpaceConstant * 2)),
            addImageButton.widthAnchor.constraint(equalToConstant: imageSizeConstant),
            addImageButton.heightAnchor.constraint(equalToConstant: imageSizeConstant),
        ])
    }
    
    private func saveData() {
        var title = self.titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        var message = self.text.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if title == "Заголовок" {
            title = ""
        }
        if message == "Описание" {
            message = ""
        }
        if !self.photos.isEmpty || !title.isEmpty || !message.isEmpty {
                if let post = self.currentPost {
                    let updatePost = Post(id: post.id, date: post.date, title: title, text: message, images: self.photos)
                    self.savePostClosure?(updatePost)
                } else {
                    let newPost = Post(id: UUID(), date: Date(), title: title, text: message, images: self.photos)
                    self.savePostClosure?(newPost)
                }
                navigationController?.dismiss(animated: true)
            } else {
                   let alert = UIAlertController(title: "Нужно добавить какую-либо информацию", message: "Фотографию или текст", preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "Ок", style: .default)
                   alert.addAction(okAction)
                   navigationController?.present(alert, animated: true)
               }
    }
    

}
extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
            let image = photos[indexPath.item]
            cell.configureCell(with: image, isEdit: true)
            self.collection?.reloadData()
            cell.removePhotoClosure = { [weak self] in
                self?.photos.remove(at: indexPath.item)
                print("remove data")
                self?.collection?.reloadData()
            }
            return cell
        }
        
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navigationController?.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
                    if !photos.contains(image) {
                        if (photos.count == 0) {
                            setupCollectionView()
                        }
                        if (photos.count < maxCountPhotos) {
                            photos.append(image)
                        }
                }
            }
        navigationController?.dismiss(animated: true)
    }
    
}
