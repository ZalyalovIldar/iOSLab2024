//
//  HeaderCollectionViewCell.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 05.01.2025.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private lazy var imageMovie: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
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
    
    func configureCell(imageURL: String) {
        activityIndicator.startAnimating()
        
        Task {
            do {
                let image = try await ImageService.downloadImage(from: imageURL)
                activityIndicator.stopAnimating()
                imageMovie.image = image
            } catch {
                print("Error download image: \(error)")
            }
        }
        
    }
    
    private func setupLayout() {
        contentView.addSubview(imageMovie)
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            imageMovie.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

extension HeaderCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
