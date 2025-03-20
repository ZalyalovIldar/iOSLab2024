//  PostTableViewCell.swift
//  Momenta
//
//  Created by Тагир Файрушин on 16.10.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Enum Collection Cell Section 
    
    enum SectionCollectionCell {
        case main
    }
    
    // MARK: Properties
    
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var postVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            postTitleLabel,
            postTextLabel,
            separatorView,
            postDateLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()
    
    private var postPhotosCollectionView: UICollectionView?
    
    private let spacingConstant: CGFloat = 10
    
    private var dataSourceCollection: UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>?
    
    private var photos: [UIImage]? {
        didSet{
            if let images = photos, !images.isEmpty{
                addCollectionView(with: images)
            } else {
                removeCollectionView()
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeCollectionView()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        contentView.backgroundColor = .systemGray6
        contentView.addSubview(whiteView)
        whiteView.addSubview(postVerticalStackView)
        
        NSLayoutConstraint.activate([
            whiteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacingConstant),
            whiteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacingConstant),
            whiteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacingConstant),
            
            postVerticalStackView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: spacingConstant),
            postVerticalStackView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: spacingConstant),
            postVerticalStackView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -spacingConstant),
            postVerticalStackView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -spacingConstant),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let bottomConstraint = whiteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
    
    // MARK: Cell Configuration
    
    func configureCell(with post: Post) {
        postTextLabel.text = post.text
        postTitleLabel.text = post.title
        postDateLabel.text = dateFormater.string(from: post.date)
        photos = post.images?.prefix(2).map{ $0 }
    }
    
    // MARK: Collection View Setup
    
    private func addCollectionView(with photos: [UIImage]) {
        guard postPhotosCollectionView == nil else { return }
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        
        postPhotosCollectionView = collectionView
        postVerticalStackView.insertArrangedSubview(collectionView, at: 0)
    
        configureDataSourceCollection(for: collectionView, with: photos)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func removeCollectionView() {
        if let collectionView = postPhotosCollectionView {
            postVerticalStackView.removeArrangedSubview(collectionView)
            collectionView.removeFromSuperview()
            postPhotosCollectionView = nil
        }
    }
    
    // MARK: Configure Collection DataSource
    
    private func configureDataSourceCollection(for collectionView: UICollectionView, with photos: [UIImage]) {
        dataSourceCollection = UICollectionViewDiffableDataSource<SectionCollectionCell, UIImage>(collectionView: collectionView, cellProvider: { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.configureCell(with: image, isEdit: false)

            return cell
        })
        
        applyDataSourceCollection(with: photos, animated: false)
    }
    
    private func applyDataSourceCollection(with photos: [UIImage], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionCollectionCell, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSourceCollection?.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - ReuseIdentifier

extension PostTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width)
    }
}

// MARK: - Selected Cell

extension PostTableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        whiteView.backgroundColor = selected ? .systemGray4 : .white
    }
}
