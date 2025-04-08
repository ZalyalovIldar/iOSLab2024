//
//  MomentTableViewCell.swift
//  momentaProject
//
//  Created by Данил Забинский on 16.10.2024.
//

import UIKit

class MomentTableViewCell: UITableViewCell, UICollectionViewDelegate {
    // MARK: Properties
    private enum CollectionViewSections: Int {
        case main
    }
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let collectionViewHeightConstant: CGFloat = 200
    private let numberOfLinesConstant = 5
    private let maxImagesInCellConstant = 2
    private let spacingFromViewConstant: CGFloat = 10
    private let avatarImageSizeConstant: CGFloat = 50
    private let separatorSizeConstant: CGFloat = 1
    private let itemSpacingConstant: CGFloat = 0
    
    private lazy var grayView: UIView = {
        let gv = UIView()
        gv.backgroundColor = .systemGray6
        gv.translatesAutoresizingMaskIntoConstraints = false
        gv.layer.cornerRadius = 10
        return gv
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = avatarImageSizeConstant / 2
        let heightAnchor = imageView.heightAnchor.constraint(equalToConstant: avatarImageSizeConstant)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
        let widthAnchor = imageView.widthAnchor.constraint(equalToConstant: avatarImageSizeConstant)
        widthAnchor.priority = .defaultHigh
        widthAnchor.isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = numberOfLinesConstant
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var titleAndDateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            dateLabel
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 6
        return stack
    }()
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray3
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: separatorSizeConstant).isActive = true
        return separatorView
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleAndDateStack,
            separatorView,
            descriptionLabel,
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    private lazy var dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy HH:mm a"
        formater.locale = .current
        formater.timeZone = TimeZone.current
        return formater
    }()

    private var momentPhotos: [UIImage]? {
        didSet {
            if let images = momentPhotos, !images.isEmpty {
                addCollectionView(with: images)
            } else {
                removeCollectionView()
            }
        }
    }
    private var momentPhotosCollectionView: UICollectionView?
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<CollectionViewSections, UIImage>?
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        removeCollectionView()
    }
    
    // MARK: Setup with moment
    func setupWithMoment(moment: Moment) {
        avatarImage.image = moment.autorsAvatar
        titleLabel.text = moment.title
        descriptionLabel.text = moment.description
        dateLabel.text = dateFormater.string(from: moment.date)
        momentPhotos = moment.photos?.prefix(maxImagesInCellConstant).map { $0 }
    }
    
    // MARK: Private methods
    private func setup() {
        setupConstraints()
    }
    // MARK: Setting up constraints
    private func setupConstraints() {
        grayView.addSubview(dataStackView)
        grayView.addSubview(avatarImage)
        contentView.addSubview(grayView)
        NSLayoutConstraint.activate([
            grayView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacingFromViewConstant / 2),
            grayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacingFromViewConstant),
            grayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacingFromViewConstant / 2),
            
            dataStackView.topAnchor.constraint(equalTo: grayView.topAnchor, constant: spacingFromViewConstant / 2),
            dataStackView.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -spacingFromViewConstant / 2),
            dataStackView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: spacingFromViewConstant),
            dataStackView.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -spacingFromViewConstant),
            
            avatarImage.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -spacingFromViewConstant / 2),
            avatarImage.centerYAnchor.constraint(equalTo: titleAndDateStack.centerYAnchor),
        ])
        let grayViewBottomAnchor = grayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacingFromViewConstant / 2)
        grayViewBottomAnchor.priority = .defaultLow
        grayViewBottomAnchor.isActive = true
//        let avatarImageLeadingAnchor = avatarImage.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: -avatarImageSizeConstant)
//        avatarImageLeadingAnchor.priority = .defaultHigh
//        avatarImageLeadingAnchor.isActive = true
    }
    
    // MARK: Adding/Removing CollectionView
    private func addCollectionView(with photos: [UIImage]) {
        guard momentPhotosCollectionView == nil else { return }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacingConstant
        layout.itemSize = CGSize(width: min(screenWidth, screenHeight) * 0.47, height: min(screenWidth, screenHeight) * 2)
        let momentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        momentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        momentCollectionView.delegate = self
        momentCollectionView.layer.cornerRadius = 10
        momentCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        
        dataStackView.addArrangedSubview(momentCollectionView)
        setupCollectionViewDataSource(for: momentCollectionView, with: photos)
        NSLayoutConstraint.activate([
            momentCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeightConstant)
        ])
        momentPhotosCollectionView = momentCollectionView
    }
    
    private func removeCollectionView() {
        if let momentCollectionView = momentPhotosCollectionView {
            dataStackView.removeArrangedSubview(momentCollectionView)
            momentCollectionView.removeFromSuperview()
            momentPhotosCollectionView = nil
        }
    }
    
    // MARK: CollectionView DiffableDataSource
    private func setupCollectionViewDataSource(for collectionView: UICollectionView, with photos: [UIImage]) {
        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, image in
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell
            let imageScale = self.isHorizontalImage(image: image)
            imageCell.setupWithImage(image, isScaleAspectFit: imageScale, deleteButtonIsHidden: true)
            return imageCell
        })
        confirmSnapshot(with: photos, animation: false)
    }
    
    private func isHorizontalImage(image: UIImage) -> Bool {
        image.size.width < image.size.height
    }

    private func confirmSnapshot(with images: [UIImage], animation: Bool) {
        var snaphot = NSDiffableDataSourceSnapshot<CollectionViewSections, UIImage>()
        snaphot.appendSections([.main])
        snaphot.appendItems(images)
        collectionViewDataSource?.apply(snaphot, animatingDifferences: animation)
    }
}

// MARK: Extention: adding property "identifier"
extension MomentTableViewCell {
    static var identifier: String {
        "\(self)"
    }
}

