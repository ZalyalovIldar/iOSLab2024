//
//  MoviesCollectionViewCell.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 02.01.2025.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImage.image = nil
        activityIndicator.stopAnimating()
    }
    
    private func setupLayout() {
        contentView.addSubview(movieImage)
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Constraint.marginSmall),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginSmall),
            movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginSmall),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Constraint.marginSmall)
        ])
    }
    
    func configureCell(imageURL: String) {
        activityIndicator.startAnimating()
        Task {
            do {
                let image = try await ImageService.downloadImage(from: imageURL)
                activityIndicator.stopAnimating()
                movieImage.image = image
            }
            catch {
                print("Error when download image for cell: \(error)")
            }
        }
    }
}

extension MovieCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
