//
//  MovieCollectionViewCell.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 31.12.2024.
//

import UIKit

class TopMovieCollectionViewCell: UICollectionViewCell {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var topNumberImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
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
        contentView.addSubview(topNumberImage)
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginHuge),
            movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Constraint.marginMassive),
            
            topNumberImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topNumberImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureCell(imageURL: String?, imageData: Data? = nil, index: Int) {
        activityIndicator.startAnimating()
        topNumberImage.image = UIImage(named: "\(index)")

        if let imageData = imageData {
            activityIndicator.stopAnimating()
            self.movieImage.image = UIImage(data: imageData)
            return
        }
        
        if let imageURL = imageURL {
            Task {
                do {
            
                    let image = try await ImageService.downloadImage(from: imageURL)
                    activityIndicator.stopAnimating()
                    self.movieImage.image = image
                }
                catch {
                    print("Error download image: \(error)")
                }
            }
        } else {
            self.movieImage.image = .default
        }
        
    }
}

extension TopMovieCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
