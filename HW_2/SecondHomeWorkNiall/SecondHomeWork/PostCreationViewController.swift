import UIKit

class PostCreationViewController: UIViewController {
    
    var post: Post?
    var didPostCreated: ((Post) -> Void)?
    private var pictures: [String] = []
    private var picSelect: [UIImage] = []
    
    lazy var postTextView: UITextView = {
        let textField = UITextView()
        textField.text = "Введите текст"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 2.0
        textField.delegate = self
        return textField
    }()
    
    private lazy var picturesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.reuseIdentifier)
        collectionView.register(AddPictureCell.self, forCellWithReuseIdentifier: "AddPictureCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        let holdingGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleHolding))
        collectionView.addGestureRecognizer(holdingGesture)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCreatingView()
        setupLayout()
        setupNavigationBar()
        if (post?.pictures != nil || post?.text != nil) {
            configureCell(with: post!)
        }
    }
    
    func setupCreatingView(){
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(picturesCollectionView)
        view.addSubview(postTextView)
        NSLayoutConstraint.activate([
            picturesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            picturesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            picturesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            picturesCollectionView.heightAnchor.constraint(equalToConstant: 150),
        
            postTextView.topAnchor.constraint(equalTo: picturesCollectionView.bottomAnchor, constant: 10),
            postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            postTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Редактирование"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(savePost))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func configureCell(with post: Post){
        postTextView.text = post.text
        pictures = post.pictures
        picSelect = []
        picturesCollectionView.reloadData()
    }
    
    private func setDate() -> String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    private func deletePhoto(at indexPath: IndexPath) {
        pictures.remove(at: indexPath.item)
        picturesCollectionView.reloadData()
    }

    func savePictureAndPath(_ image: UIImage) -> String {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return ""
        }
        let imageName = UUID().uuidString + ".png"
        let imageURL = docs.appendingPathComponent(imageName)
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: imageURL)
                print((imageURL.path))
                return imageURL.path
            } catch {
                print((error.localizedDescription))
            }
        }
        
        return ""
    }
    
    @objc func savePost() {
        if postTextView.text == "Введите текст"{
            postTextView.text = ""
        }
        guard let description = postTextView.text, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  || !pictures.isEmpty else {
            let alert = UIAlertController(title: "Пустой пост", message: "Нельзя сохранить", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            postTextView.text = "Введите текст"
            postTextView.textColor = .lightGray
            return }
        let picturePaths = picSelect.map { image in savePictureAndPath(image)}
        pictures += picturePaths
        let updatedPost: Post
        
        if let postId = post?.id {
            updatedPost = Post(text: description, date: setDate(), pictures: pictures, id: postId)
        } else {
            updatedPost = Post(text: description, date: setDate(), pictures: pictures, id: UUID())
        }
        didPostCreated?(updatedPost)
        dismiss(animated: true, completion: nil)
    }

    @objc private func handleHolding(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: picturesCollectionView)
        guard let indexPath = picturesCollectionView.indexPathForItem(at: location) else { return }
        
        if gesture.state == .began {
            let alert = UIAlertController(title: "Удалить фото?", message: "Вы уверены, что хотите удалить данное фото?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.deletePhoto(at: indexPath)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}


extension PostCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count < 4 ? pictures.count + 1 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < pictures.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseIdentifier, for: indexPath) as! PictureCell
            cell.imageView.image = UIImage(named: pictures[indexPath.item])
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPictureCell.reuseID, for: indexPath) as! AddPictureCell
            cell.addPictureAction = { [weak self] in
                self?.addPhotoTapped()
            }
            return cell
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if pictures.count < 4 {
                if let data = image.jpegData(compressionQuality: 1.0) {
                    let filename = UUID().uuidString + ".jpg"
                    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    do {
                        try data.write(to: fileURL)
                        pictures.append(fileURL.path)
                        picturesCollectionView.reloadData()
                    } catch {
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

extension PostCreationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == postTextView && textView.text == "Введите текст" {
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

