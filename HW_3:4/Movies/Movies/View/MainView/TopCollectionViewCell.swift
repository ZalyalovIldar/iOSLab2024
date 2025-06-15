//
//  TopCollectionViewCell.swift
//  Movies
//
//  Created by Павел Калинин on 21.12.2024.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    private var imageTask: Task<Void, Never>?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = AppColors.searchGray
        return imageView
    }()
    
    private lazy var numberLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.font = .systemFont(ofSize: 95, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -15),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 42),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with movie: Movie, index: Int) {
        activityIndicator.startAnimating()
        numberLabel.text = "\(index + 1)"
        imageTask = Task {
            defer { activityIndicator.stopAnimating() }
            imageView.image = try? await ImageService.shared.downloadImage(url: movie.poster.image)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        cancelImageDownload()
    }
    
    private func cancelImageDownload() {
        imageTask?.cancel()
        imageTask = nil
    }
}

extension TopCollectionViewCell {
    static let reuseIdentifier = "TopCollectionViewCell"
}
