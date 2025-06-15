//
//  PostTableViewCell.swift
//  homework2
//
//  Created by Ильнур Салахов on 20.10.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    lazy var textPostLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var datePostLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.text = "25.05.2005"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var photoCollectionView: UICollectionView!
    
    private var post: Post?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPhotoCollectionView()
        setupLayout()
    }
    
    private func setupPhotoCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150) 
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.dataSource = self
        photoCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [datePostLabel, textPostLabel, photoCollectionView])
                stackView.axis = .vertical
                stackView.spacing = 8
                contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
                ])
    }
    
    func configure(with post: Post) {
        self.post = post
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        datePostLabel.text = dateFormatter.string(from: post.date)
        
        textPostLabel.text = post.text

        photoCollectionView.reloadData()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(post?.images.count ?? 0, 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            if let image = post?.images[indexPath.item] {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 8
                cell.contentView.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                ])
            }
            
            return cell
        }
}
