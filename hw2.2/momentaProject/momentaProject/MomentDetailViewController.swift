//
//  MomentDetailViewController.swift
//  momentaProject
//
//  Created by Данил Забинский on 17.10.2024.
//

import UIKit
// MARK: Deleting moment protocol
protocol MomentDetailVCDelegate: AnyObject {
    func deleteMoment(with moment: Moment)
}

class MomentDetailViewController: UIViewController {
    // MARK: Properties
    private enum CollectionViewSections: Int {
        case main
    }
    private struct Constants {
        static let lineSpacingConstant: CGFloat = 0
        static let spacingFromViewConstant: CGFloat = 10
        static let buttonSizeConstant: CGFloat = 60
        static let separatorSizeConstant: CGFloat = 1
        static let screenHeight = UIScreen.main.bounds.height
        static let screenWidth = UIScreen.main.bounds.width
    }
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var avatarImage: UIImageView = {
        let iv = UIImageView(image: currentMoment.autorsAvatar)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = currentMoment.title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = currentMoment.description
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = dateFormater.string(from: currentMoment.date)
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            presentDeleteAlertMessage()
        }
        let button = UIButton(type: .custom, primaryAction: deleteAction)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.backgroundColor = .systemGray6
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleAndDateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            dateLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            avatarImage,
            titleAndDateStackView,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray3
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerStackView,
            separatorView,
            descriptionLabel,
            momentPhotosCollectionView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var momentPhotosCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = Constants.lineSpacingConstant
        flowLayout.minimumInteritemSpacing = Constants.lineSpacingConstant
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray5
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy HH:mm a"
        formater.locale = .current
        formater.timeZone = TimeZone.current
        return formater
    }()
    
    private lazy var momentPhotos: [UIImage] = {
        guard let images = currentMoment.photos else { return [] }
        return images.prefix(4).map { $0 }
    }()
    private var currentMoment: Moment!
    private var currentMomentIndex: Int!
    private weak var delegate: MomentDetailVCDelegate?
    private var momentPhotosCollectionViewDataSource: UICollectionViewDiffableDataSource<CollectionViewSections, UIImage>?
    // MARK: Share created moment with VC
    var shareCreatedMomentIntoTableView: ((Moment, Int) -> Void)?
    
    // MARK: Init
    init(with moment: Moment, withIndex index: Int, delegate: MomentDetailVCDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.currentMoment = moment
        self.currentMomentIndex = index
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewWillTransition method
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.momentPhotosCollectionView.collectionViewLayout.invalidateLayout()
            self.confirmSnaphot(with: self.momentPhotos, animation: false)
        }
    }
    
    // MARK: Private methods
    private func setup() {
        view.backgroundColor = .white
        setupConstraints()
        setupNavigationBar()
        setupMomentPhotosCollectionViewDataSource()
        configurateHeihgtToCollectionView()
    }
    
    // MARK: Setup constraints
    private func setupConstraints() {
        contentView.addSubview(dataStackView)
        contentView.addSubview(deleteButton)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.spacingFromViewConstant),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacingFromViewConstant),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacingFromViewConstant),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacingFromViewConstant),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacingFromViewConstant),
            dataStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacingFromViewConstant),
            dataStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacingFromViewConstant),
            dataStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacingFromViewConstant),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.buttonSizeConstant),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            
            avatarImage.heightAnchor.constraint(equalToConstant: Constants.buttonSizeConstant),
            avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorSizeConstant),
        ])
        let deleteButtonLeadingAnchor = deleteButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.buttonSizeConstant)
        deleteButtonLeadingAnchor.priority = .defaultHigh
        deleteButtonLeadingAnchor.isActive = true
    }
    
    // MARK: Setup navigation bar
    private func setupNavigationBar() {
        navigationItem.title = currentMoment.title
        let editAction = UIAction { _ in
            let createMomentViewController = CreateMomentViewController(with: self.currentMoment)
            let navigationCreateMomentViewController = UINavigationController(rootViewController: createMomentViewController)
            self.present(navigationCreateMomentViewController, animated: true)
            
            createMomentViewController.saveCreatedMomentClosure = { moment in
                self.shareCreatedMomentIntoTableView?(moment, self.currentMomentIndex)
            }
        }
        let editButton = UIBarButtonItem(systemItem: .edit, primaryAction: editAction)
        navigationItem.rightBarButtonItem = editButton
    }
    
    // MARK: Collection View diffable data source
    private func setupMomentPhotosCollectionViewDataSource() {
        momentPhotosCollectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: momentPhotosCollectionView, cellProvider: { collectionView, indexPath, image in
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell
            imageCell.setupWithImage(image, isScaleAspectFit: false, deleteButtonIsHidden: true)
            return imageCell
        })
        confirmSnaphot(with: momentPhotos, animation: false)
    }
    
    private func confirmSnaphot(with images: [UIImage], animation: Bool) {
        var snaphot = NSDiffableDataSourceSnapshot<CollectionViewSections, UIImage>()
        snaphot.appendSections([.main])
        snaphot.appendItems(images)
        momentPhotosCollectionViewDataSource?.apply(snaphot, animatingDifferences: animation)
    }
    
    // MARK: Height to CollectionView
    private func configurateHeihgtToCollectionView() {
        switch momentPhotos.count {
        case 0:
            NSLayoutConstraint.activate([
                momentPhotosCollectionView.heightAnchor.constraint(equalToConstant: 0)
            ])
        case 1, 2:
            NSLayoutConstraint.activate([
                momentPhotosCollectionView.heightAnchor.constraint(equalToConstant: Constants.screenHeight / 3)
            ])
        default:
            NSLayoutConstraint.activate([
                momentPhotosCollectionView.heightAnchor.constraint(equalToConstant: Constants.screenHeight / 2)
            ])
        }
    }
    
    // MARK: "Delete" alert
    private func presentDeleteAlertMessage() {
        let deleteAlert = UIAlertController(title: "Delete \(self.currentMoment.title) from moments?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.deleteMoment(with: self.currentMoment)
            self.navigationController?.popViewController(animated: true)
        }
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        self.present(deleteAlert, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MomentDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let totalHeight = collectionView.bounds.height
        let itemCount = momentPhotos.count
        
        if itemCount == 1 {
            return CGSize(width: totalWidth, height: totalHeight)
        } else if itemCount == 2 {
            return CGSize(width: totalWidth / 2, height: totalHeight)
        } else if itemCount == 3 {
            return CGSize(width: (indexPath.item == 2) ? totalWidth : totalWidth / 2,
                          height: (indexPath.item == 2) ? totalHeight / 2 : totalHeight / 2)
        } else {
            return CGSize(width: totalWidth / 2, height: totalHeight / 2)
        }
    }
}
