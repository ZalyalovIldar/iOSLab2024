//
//  CreatePostViewController.swift
//  Momenta
//
//  Created by Тагир Файрушин on 19.10.2024.
//

import UIKit
import PhotosUI

class CreatePostViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var titleTextView: UITextView = {
        let title = UITextView()
        title.font = UIFont.boldSystemFont(ofSize: 24)
        title.text = "Заголовок"
        title.textColor = .lightGray
        title.isScrollEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.delegate = self
        return title
    }()
    
    private lazy var messageTextView: UITextView = {
        let message = UITextView()
        message.text = "Начните писать..."
        message.textColor = .lightGray
        message.font = UIFont.systemFont(ofSize: 16)
        message.isScrollEnabled = false
        message.translatesAutoresizingMaskIntoConstraints = false
        message.delegate = self
        return message
    }()
    
    private lazy var dateFormmatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM"
        return dateFormatter
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var postStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleTextView,
            separatorView,
            messageTextView,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var addPhotosButton: UIButton = {
        var configureButton = UIButton.Configuration.plain()
        configureButton.image = UIImage(systemName: "photo.badge.plus")
        configureButton.baseBackgroundColor = .systemBlue
        
        let action = UIAction { [weak self] _ in
            self?.addPickerController()
        }
        
        let button = UIButton(configuration: configureButton, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemGray6
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var savePostAction: UIAction = UIAction { _ in
        var title = self.titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        var message = self.messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if title == "Заголовок" {
            title = ""
        }
        if message == "Начните писать..." {
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
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Нужно добавить какую-либо информацию", message: "Фотки или текст", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private lazy var toolbarKeyboard: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    private final let maxCountPhotos = 4
    
    private var postPhotosCollectionView: UICollectionView?
    
    private var photos: [UIImage] = [] {
        didSet {
            if !photos.isEmpty {
                addCollectionView()
            } else {
                postPhotosCollectionView?.isHidden = true
            }
        }
    }
    
    private let photoSizeConstant: CGFloat = 60
    
    private let spacingConstant: CGFloat = 10
    
    private var postDate: Date?
    
    private var currentPost: Post?
    
    // MARK: - Delegate Closure
    
    var savePostClosure: ((Post) -> Void)?
    
    // MARK: - Initializers
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.currentPost = post
        self.titleTextView.text = post.title
        self.messageTextView.text = post.text
        self.postDate = post.date
        self.messageTextView.textColor = .black
        self.titleTextView.textColor = .black
        if let images = post.images, !images.isEmpty {
            self.photos = images
            self.addCollectionView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        configureNavigationController()
        setupKeyboardObservers()
        configureToolbar()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        scrollView.addSubview(contentView)
        contentView.addSubview(postStackView)
        view.addSubview(scrollView)
        view.addSubview(addPhotosButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            postStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacingConstant * 2),
            postStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacingConstant),
            postStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacingConstant),
            postStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            addPhotosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotosButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(spacingConstant * 2)),
            addPhotosButton.widthAnchor.constraint(equalToConstant: photoSizeConstant),
            addPhotosButton.heightAnchor.constraint(equalToConstant: photoSizeConstant),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Setup Keyboard Observers
    
    // Взято с интернета, сам не смог починить
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self?.scrollView.contentInset.bottom = keyboardHeight
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.scrollView.contentInset.bottom = 0
        }
    }
    
    // MARK: - Configure Navigation Controller
    
    private func configureNavigationController() {
        let cancelAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", primaryAction: self.savePostAction)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", primaryAction: cancelAction)
        navigationItem.title = dateFormmatter.string(from: postDate ?? Date())
    }
    
    // MARK: - Configure Toolbar
    
    private func configureToolbar() {
        let actionDone = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
        }
        
        let doneButton = UIBarButtonItem(title: "Готово", primaryAction: actionDone, menu: nil)
        toolbarKeyboard.sizeToFit()
        toolbarKeyboard.setItems([doneButton], animated: false)
        
        titleTextView.inputAccessoryView = toolbarKeyboard
        messageTextView.inputAccessoryView = toolbarKeyboard
        
        NSLayoutConstraint.activate([
            toolbarKeyboard.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Picker Controller
    
    private func addPickerController() {
        if photos.count < maxCountPhotos {
            var configurePicker = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            configurePicker.filter = .images
            configurePicker.selectionLimit = maxCountPhotos - photos.count
            
            let pickerVC = PHPickerViewController(configuration: configurePicker)
            pickerVC.delegate = self
            self.present(pickerVC, animated: true)
        } else {
            let allert = UIAlertController(title: "Привышен лимит загрузки фотографий", message: "максимум 4 фотографии", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            allert.addAction(okAction)
            self.present(allert, animated: true)
        }
    }
    
    private func addCollectionView() {
        guard postPhotosCollectionView == nil else {
            postPhotosCollectionView?.isHidden = false
            return
        }
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        
        postStackView.insertArrangedSubview(collectionView, at: 0)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 400),
        ])
        
        postPhotosCollectionView = collectionView
    }
}

// MARK: UICollectionViewDelegateFlowLayout && UICollectionViewDataSource

extension CreatePostViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let image = photos[indexPath.item]
        cell.configureCell(with: image, isEdit: true)
        cell.removePhotoClosure = { [weak self] in
            guard let self = self else { return }

            self.photos.remove(at: indexPath.item)
            self.postPhotosCollectionView?.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        let lineSpacing: CGFloat = 5
        
        switch photos.count {
        case 1:
            return CGSize(width: width, height: height)
        case 2:
            return CGSize(width: (width - lineSpacing) / 2, height: height)
        case 3:
            if indexPath.item == 2 {
                return CGSize(width: width, height: (height / 2) - lineSpacing)
            } else {
                return CGSize(width: (width - lineSpacing) / 2, height: (height / 2) - lineSpacing)
            }
        case 4:
            return CGSize(width: (width - lineSpacing) / 2, height: (height / 2) - lineSpacing)
        default:
            return CGSize(width: width, height: height)
        }
    }
}

// MARK: PHPickerViewControllerDelegate

extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            let itemProvider = result.itemProvider // Для загрузки элемента
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.photos.append(image)
                            self?.postPhotosCollectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: UITextViewDelegate

extension CreatePostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView && textView.text == "Заголовок" {
            textView.text = ""
            textView.textColor = .black
        } else if textView == messageTextView && textView.text == "Начните писать..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.insertText("\n")
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView && textView.text.isEmpty{
            textView.text = "Заголовок"
            textView.textColor = .lightGray
        } else if textView == messageTextView && textView.text.isEmpty {
            textView.text = "Начните писать..."
            textView.textColor = .lightGray
        }
    }
}
