//
//  FilmCollectionViewCell.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 24.12.2024.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    
    private var loadImageTask: Task<Void, Never>?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemGray6
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var filmImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.tiny
        return image
    }()
    
    private lazy var filmPosition: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: Constants.screenWidth / 5),
            image.widthAnchor.constraint(equalToConstant: Constants.screenWidth / 5),
        ])
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadImageTask?.cancel()
        loadImageTask = nil
        filmImage.image = nil
    }
    
    func configurePopularFilm(_ film: Film, at position: Int, didLoadData: Bool) {
        loadingIndicator.startAnimating()
        filmPosition.image = UIImage(named: "\(position)")
        setupWithPositionImage()
        
        loadImageTask = Task {
            if didLoadData {
                if let imageData = Data(base64Encoded: film.poster.image), let image = UIImage(data: imageData) {
                    if !Task.isCancelled {
                        loadingIndicator.stopAnimating()
                        filmImage.image = image
                    }
                }
            } else {
                do {
                    let image = try await ImageService.downloadImage(from: film.poster.image)
                    if !Task.isCancelled {
                        loadingIndicator.stopAnimating()
                        filmImage.image = image
                    }
                } catch {
                    if !Task.isCancelled {
                        self.loadingIndicator.stopAnimating()
                        self.filmImage.image = .failToLoad
                    }
                }
            }
        }
    }
    
    func configureFilm(_ film: Film) {
        loadingIndicator.startAnimating()
        setupWithoutPositionImage()
        
        loadImageTask = Task {
            do {
                let image = try await ImageService.downloadImage(from: film.poster.image)
                if !Task.isCancelled {
                    loadingIndicator.stopAnimating()
                    filmImage.image = image
                }
            } catch {
                if !Task.isCancelled {
                    self.loadingIndicator.stopAnimating()
                    self.filmImage.image = .failToLoad
                }
            }
        }
    }
    
    private func setupWithPositionImage() {
        addSubview(loadingIndicator)
        addSubview(filmImage)
        addSubview(filmPosition)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            filmImage.topAnchor.constraint(equalTo: self.topAnchor),
            filmImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.small),
            filmImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.small),
            filmImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            filmPosition.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.nothing),
            filmPosition.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -Constants.ultraTiny),
        ])
    }
    
    private func setupWithoutPositionImage() {
        addSubview(loadingIndicator)
        addSubview(filmImage)
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            filmImage.topAnchor.constraint(equalTo: self.topAnchor),
            filmImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            filmImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filmImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

extension FilmCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}   
