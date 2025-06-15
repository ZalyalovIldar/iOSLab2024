import UIKit

class AddViewController: UIViewController {
    var post: Post?
    var postId: UUID!
    var onSave: ((Post) -> Void)?
    private var photos: [String] = []
    private var selectedImages: [UIImage] = []
    
    private lazy var postTextView: UITextView = {
        let textField = UITextView()
        textField.text = "Введите текст"
        textField.textColor = .lightGray
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupNavigationBar()
        if post != nil {
            configureData(with: post!)
        }
    }
    
    func configureData(with post: Post) {
        if !post.description.isEmpty {
            postTextView.textColor = .black
        }
        postTextView.text = post.description
        photos = post.pictures
        selectedImages = []
        postId = post.id
        photosCollectionView.reloadData()
    }
    
    private func setupLayout() {
        view.addSubview(photosCollectionView)
        view.addSubview(postTextView)
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 150),
        
            postTextView.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 10),
            postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            postTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            postTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Редактирование"
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePost))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func savePost() {
        if postTextView.text == "Введите текст"{
            postTextView.text = ""
        }
        guard let description = postTextView.text, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  || !photos.isEmpty else {
            let alert = UIAlertController(title: "Пустой пост", message: "Сохранение невозможно", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            postTextView.text = "Введите текст"
            postTextView.textColor = .lightGray
            return }
        let picturePaths = selectedImages.map { image in
            saveImageAndReturnPath(image)}
        photos += picturePaths
        let updatedPost: Post
        if let postId = post?.id {
            updatedPost = Post(date: setDate(), description: description, pictures: photos, id: postId)
        } else {
            updatedPost = Post(date: setDate(), description: description, pictures: photos, id: UUID())
        }
        onSave?(updatedPost)
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageAndReturnPath(_ image: UIImage) -> String {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return ""
        }
        let imageName = UUID().uuidString + ".png"
        let imageURL = documentsDirectory.appendingPathComponent(imageName)
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: imageURL)
                print("Изображение сохранено по пути: (imageURL.path)")
                return imageURL.path
            } catch {
                print("Ошибка при сохранении изображения: (error.localizedDescription)")
            }
        }
        return ""
    }
    
    private func setDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: photosCollectionView)
        guard let indexPath = photosCollectionView.indexPathForItem(at: location) else { return }
        if photosCollectionView.cellForItem(at: indexPath)?.reuseIdentifier == AddPhotoCell.reuseIdentifier  { return }

        if gesture.state == .began {
            let alert = UIAlertController(title: "Удалить фото?", message: "Вы уверены, что хотите удалить это фото?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.deletePhoto(at: indexPath)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func deletePhoto(at indexPath: IndexPath) {
        photos.remove(at: indexPath.item)
        photosCollectionView.reloadData()
    }
}

extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count < 4 ? photos.count + 1 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < photos.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
            cell.imageView.image = UIImage(named: photos[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.reuseIdentifier, for: indexPath) as! AddPhotoCell
            cell.addPhotoAction = { [weak self] in
                self?.addPhotoTapped()
            }
            return cell
        }
    }
    
    @objc func addPhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if photos.count < 4 {
                if let data = image.jpegData(compressionQuality: 1.0) {
                    let filename = UUID().uuidString + ".jpg"
                    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    do {
                        try data.write(to: fileURL)
                        photos.append(fileURL.path)
                        photosCollectionView.reloadData()
                    } catch {
                        print("Ошибка сохранения изображения: \(error)")
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

class AddPhotoCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addPhotoAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addButton)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemGray5
        addButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 150),
            addButton.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func addPhotoTapped() {
        addPhotoAction?()
    }
}
extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == postTextView && textView.text == "Введите текст" || textView.text == ""{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == postTextView && textView.text.isEmpty {
            textView.text = "Введите текст"
            textView.textColor = .lightGray
        }
    }
}

