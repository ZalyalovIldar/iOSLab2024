//
//  CreateMomentViewController.swift
//  momentaProject
//
//  Created by Данил Забинский on 19.10.2024.
//

import UIKit
import PhotosUI

class CreateMomentViewController: UIViewController {
    // MARK: Properties
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let maxImages = 4
    private let lineSpacingConstant: CGFloat = 0
    private let spacingFromViewConstant: CGFloat = 10
    private let textFieldHeightConstant: CGFloat = 100
    
    private lazy var navigationBarView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        setupText()
        return customView
        
        func setupText() {
            customView.addSubview(headerStackView)
            NSLayoutConstraint.activate([
                headerStackView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
                headerStackView.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            ])
        }
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var createMomentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moment"
        label.textColor = .systemGray
        label.font = .italicSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var sparkleImage: UIImageView  = {
        let image = UIImageView(image: UIImage(systemName: "sparkles"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .black
        return image
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            createMomentLabel,
            sparkleImage
        ])
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titlePromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the title of the moment"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleUITextView: UITextView = {
        let text = UITextView()
        text.isEditable = true
        text.isSelectable = true
        text.isScrollEnabled = true
        text.returnKeyType = .done
        text.font = .boldSystemFont(ofSize: 20)
        text.layer.cornerRadius = 10
        text.backgroundColor = .systemGray6
        text.translatesAutoresizingMaskIntoConstraints = false
        text.delegate = self
        let hideKeyboardAction = UIAction { _ in
            text.resignFirstResponder()
        }
        text.addDoneButton(title: "Done", target: self, action: hideKeyboardAction)
        return text
    }()
    
    private lazy var firstInputField: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titlePromptLabel,
            titleUITextView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    private lazy var descriptionPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the description of the moment"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var descriptionUITextView: UITextView = {
        let text = UITextView()
        text.isEditable = true
        text.isSelectable = true
        text.isScrollEnabled = true
        text.returnKeyType = .done
        text.font = .systemFont(ofSize: 18)
        text.layer.cornerRadius = 10
        text.backgroundColor = .systemGray6
        text.translatesAutoresizingMaskIntoConstraints = false
        text.delegate = self
        let hideKeyboardAction = UIAction { _ in
            text.resignFirstResponder()
        }
        text.addDoneButton(title: "Done", target: self, action: hideKeyboardAction)
        return text
    }()
    
    private lazy var secondInputField: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            descriptionPromptLabel,
            descriptionUITextView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var addPhotosButton: UIButton = {
        let showPickerAction = UIAction { _ in
            self.showPHPicker()
        }
        let button = UIButton(configuration: .filled(), primaryAction: showPickerAction)
        button.setImage(UIImage(systemName: "photo.badge.arrow.down")!, for: .normal)
        button.tintColor = view.backgroundColor
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var separatorStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            separatorView,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
    
    private lazy var dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy.MM.dd HH:mm"
        return formater
    }()
    
    private var momentPhotosCollectionView: UICollectionView?
    private var momentPhotos: [UIImage]? {
        didSet {
            if let photos = momentPhotos, !photos.isEmpty {
                createCollectionView(with: photos)
            } else {
                removeCollectionView()
            }
        }
    }
    // MARK: Save moment closure
    var saveCreatedMomentClosure: ((Moment) -> Void)?
    private var currentMoment: Moment?
    private var isEditingExistingMoment: Bool = false
    
    // MARK: Default init
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    // MARK: Custom init with moment
    init(with moment: Moment) {
        super.init(nibName: nil, bundle: nil)
        self.currentMoment = moment
        self.titleUITextView.text = moment.title
        self.descriptionUITextView.text = moment.description
        if let photos = moment.photos {
            self.momentPhotos = photos
            createCollectionView(with: self.momentPhotos!)
        }
        self.isEditingExistingMoment.toggle()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods
    private func setup() {
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: Setup constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        scrollView.addSubview(contentView)
        contentView.addSubview(firstInputField)
        contentView.addSubview(secondInputField)
        contentView.addSubview(addPhotosButton)
        contentView.addSubview(separatorStackView)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingFromViewConstant),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingFromViewConstant),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingFromViewConstant),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacingFromViewConstant),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            firstInputField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacingFromViewConstant * 2),
            firstInputField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            secondInputField.topAnchor.constraint(equalTo: firstInputField.bottomAnchor, constant: spacingFromViewConstant * 2),
            secondInputField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            addPhotosButton.topAnchor.constraint(equalTo: secondInputField.bottomAnchor, constant: 15),
            addPhotosButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            separatorStackView.topAnchor.constraint(equalTo: addPhotosButton.bottomAnchor, constant: spacingFromViewConstant  * 3),
            separatorStackView.centerXAnchor.constraint(equalTo: addPhotosButton.centerXAnchor),
            separatorStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleUITextView.heightAnchor.constraint(equalToConstant: textFieldHeightConstant / 2),
            titleUITextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            descriptionUITextView.heightAnchor.constraint(equalToConstant: textFieldHeightConstant),
            descriptionUITextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            
            sparkleImage.heightAnchor.constraint(equalTo: navigationBarView.heightAnchor, multiplier: 0.75),
            sparkleImage.widthAnchor.constraint(equalTo: navigationBarView.heightAnchor, multiplier: 0.5),
        ])
    }
    
    // MARK: PHPicker
    private func showPHPicker() {
        let quantityOfMomentPhotos = momentPhotos?.count ?? 0
        if quantityOfMomentPhotos < maxImages {
            var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            configuration.filter = .images
            configuration.selectionLimit = maxImages - quantityOfMomentPhotos
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        } else {
            let warningAlert = UIAlertController(title: "Too much images!", message: "You can't add more than \(maxImages) images", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            warningAlert.addAction(okAction)
            present(warningAlert, animated: true)
        }
    }
    
    // MARK: Creating CollectionView
    private func createCollectionView(with images: [UIImage]) {
        guard momentPhotosCollectionView == nil else { return }
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = lineSpacingConstant
        collectionViewLayout.minimumInteritemSpacing = lineSpacingConstant
        collectionViewLayout.itemSize = .init(width: (screenWidth - lineSpacingConstant) / 2,                                        height: (screenWidth - lineSpacingConstant) / 2)
        collectionViewLayout.scrollDirection = .vertical
        
        let selectedImagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        selectedImagesCollectionView.dataSource = self
        selectedImagesCollectionView.delegate = self
        selectedImagesCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        selectedImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        separatorStackView.addArrangedSubview(selectedImagesCollectionView)
        NSLayoutConstraint.activate([
            selectedImagesCollectionView.heightAnchor.constraint(equalToConstant: screenWidth),
            selectedImagesCollectionView.widthAnchor.constraint(equalToConstant: screenWidth)
        ])
        momentPhotosCollectionView = selectedImagesCollectionView
    }
    
    // MARK: Removing Collection View`
    private func removeCollectionView() {
        if let momentCollectionView = momentPhotosCollectionView {
            separatorStackView.removeArrangedSubview(momentCollectionView)
            momentCollectionView.removeFromSuperview()
            momentPhotosCollectionView = nil
        }
    }
    
    // MARK: "Is text valid" method
    private func isTextViewEmptyOrOnlySpaces(text: String?) -> Bool {
        guard let text = text else { return false }
        let whitspacesCount = text.filter { $0 != " " }.count
        return (whitspacesCount != 0) && !text.isEmpty
    }
    
    // MARK: Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.titleView = navigationBarView
        let saveAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let firstText = self.titleUITextView.text
            if isTextViewEmptyOrOnlySpaces(text: firstText) {
                let secondText = self.descriptionUITextView.text
                if isTextViewEmptyOrOnlySpaces(text: secondText!) || !(momentPhotos?.isEmpty ?? true) {
                    let newIdForFreshMoment = self.isEditingExistingMoment ? currentMoment!.id : UUID()
                    let freshMoment = Moment(id: newIdForFreshMoment,
                                             autorsAvatar: .avatar,
                                             title: firstText!,
                                             date: Date(),
                                             description: secondText,
                                             photos: (momentPhotos?.isEmpty ?? true) ? nil : momentPhotos)
                    saveCreatedMomentClosure?(freshMoment)
                    presentSavedAlert()
                } else {
                    presentInvalidDescriptionOrEmptyImagesAlert()
                }
            } else {
                presentInvalidTitleAlert()
            }
        }
        let pushBackAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", primaryAction: saveAction)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", primaryAction: pushBackAction)
    }
    
    // MARK: Present "Saved" alert
    private func presentSavedAlert() {
        let saveAlert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
        self.present(saveAlert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                saveAlert.dismiss(animated: true) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    // MARK: Present "Invalid Data" alert
    private func presentInvalidTitleAlert() {
        titleUITextView.text.removeAll()
        let warningTextAlert = UIAlertController(title: "Title should not be a nil value!", message: "Enter your title again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        warningTextAlert.addAction(okAction)
        self.present(warningTextAlert, animated: true)
    }
    
    private func presentInvalidDescriptionOrEmptyImagesAlert() {
        let warningAlert = UIAlertController(title: "Wrong data", message: "The Moment post must contains image or description", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        warningAlert.addAction(okAction)
        present(warningAlert, animated: true)
        descriptionUITextView.text.removeAll()
    }
}

// MARK: Extension to conform UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource
extension CreateMomentViewController: UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        momentPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let images = momentPhotos else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell
        cell.setupWithImage(images[indexPath.item], isScaleAspectFit: false, deleteButtonIsHidden: false)
        cell.deleteImageClosure = { [weak self] in
            guard let self else { return }
            self.momentPhotos?.remove(at: indexPath.item)
            self.momentPhotosCollectionView?.reloadData()
        }
        return cell
    }
}

// MARK: Extension to conform PHPickerViewControllerDelegate
extension CreateMomentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if momentPhotos == nil { momentPhotos = [] }
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.momentPhotos?.append(image)
                            self.momentPhotosCollectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: Extension to add "Hide keyboard" button
extension UITextView {
    func addDoneButton(title: String, target: Any, action: UIAction) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44))
        let barButton = UIBarButtonItem(title: "Done", primaryAction: action)
        toolBar.setItems([barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
