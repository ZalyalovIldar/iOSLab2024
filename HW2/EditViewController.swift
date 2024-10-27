import UIKit

class EditViewController: UIViewController {
    private var images: [UIImage] = [] {
        didSet { limitImagesToMaxCount() }
    }
    private let maxImagesCount = 4
    private var moment: Moment?
    var completion: ((Moment) -> Void)?

    init(moment: Moment? = nil) {
        self.moment = moment
        super.init(nibName: nil, bundle: nil)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var photoLabel = createLabel(withText: "Фото")
    private lazy var descriptionLabel = createLabel(withText: "Описание")

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.5
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = createBarButtonItem(title: "Отмена", action: #selector(dismissView))
        navigationItem.rightBarButtonItem = createBarButtonItem(title: "Сохранить", action: #selector(saveMoment))
    }

    private func setupUI() {
        [photoLabel, collectionView, descriptionLabel, descriptionTextView].forEach { view.addSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            photoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

            collectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }

    private func configureView() {
        if let moment = moment {
            images = moment.images
            descriptionTextView.text = moment.description
        }
    }

    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain, target: self, action: action)
    }

    private func limitImagesToMaxCount() {
        if images.count > maxImagesCount {
            images = Array(images.prefix(maxImagesCount))
        }
    }

    @objc private func dismissView() {
        dismiss(animated: true)
    }

    @objc private func saveMoment() {
        guard !images.isEmpty || !descriptionTextView.text.isEmpty else {
            showAlert(title: "Пусто", message: "Добавьте фото или введите текст")
            return
        }

        let newMoment = Moment(id: moment?.id ?? UUID(), date: moment?.date ?? Date(), images: images, description: descriptionTextView.text)
        completion?(newMoment)
        dismiss(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count < maxImagesCount ? images.count + 1 : images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell

        if indexPath.item < images.count {
            cell.configure(with: images[indexPath.item], isAddButton: false)
            cell.onDelete = { [weak self] in
                guard let self = self else { return }
                self.images.remove(at: indexPath.item)
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
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func openImagePicker() {
        guard images.count < maxImagesCount, UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let selectedImage = info[.originalImage] as? UIImage {
            images.append(selectedImage)
            collectionView.reloadData()
        }
    }
}
