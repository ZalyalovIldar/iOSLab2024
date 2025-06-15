import UIKit

protocol CreatePostDelegate: AnyObject {
    func didCreatePost(_ post: Post)
}

class CreatePostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: CreatePostDelegate?
    var textView = UITextView()
    private var photoCollectionView: UICollectionView!
    var selectedImages = [UIImage?]()
    private let maxImages = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupTextView()
        setupPhotoCollectionView()
        
    }
    
    private func setupNavigationBar() {
        title = "Новый пост" 
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(savePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelPost))
    }
    
    private func setupTextView() {
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
        let postText = textView.text ?? ""
        let newPost = Post(text: postText, date: Date(), images: selectedImages)
        delegate?.didCreatePost(newPost)
        
        dismiss(animated: true, completion: nil)
    }

    
    @objc private func cancelPost() {
        dismiss(animated: true, completion: nil)
    }
    
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

class PhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoCell"
    private let imageView = UIImageView()
    private let deleteButton = UIButton(type: .close)
    
    var onDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
        deleteButton.isHidden = false
    }
    
    func configureAsAddButton() {
        imageView.image = UIImage(systemName: "plus")
        imageView.contentMode = .center
        deleteButton.isHidden = true
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}

