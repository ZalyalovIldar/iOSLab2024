//
//  FilmCollectionViewCell.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    
    private var loadImageTask: Task<Void, Never>?
    static var identifier: String { "\(self)" }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemGray6
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var filmPoster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = SpacingConstants.small
        return image
    }()
    
    private lazy var filmPosition: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: SpacingConstants.width / 5),
            image.widthAnchor.constraint(equalToConstant: SpacingConstants.width / 5),
        ])
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadImageTask?.cancel()
        loadImageTask = nil
        filmPoster.image = nil
    }
    
    func configurePopularFilm(_ film: Film, at position: Int, didLoadData: Bool) {
        activityIndicator.startAnimating()
        filmPosition.image = UIImage(named: "\(position)")
        
        setupWithPositionImage()
        
        loadImageTask = Task {
            if didLoadData {
                
                if let imageData = Data(base64Encoded: film.poster.image) {
                    let image = UIImage(data: imageData)
                    if !Task.isCancelled {
                        activityIndicator.stopAnimating()
                        filmPoster.image = image
                    }
                }
            } else {
                
                do {
                    let image = try await ImageService.downloadImage(from: film.poster.image)
                    if !Task.isCancelled {
                        activityIndicator.stopAnimating()
                        filmPoster.image = image
                    }
                } catch {
                    if !Task.isCancelled {
                        self.activityIndicator.stopAnimating()
                        filmPoster.image = UIImage(named: "photo")
                    }
                }
            }
        }
    }
    
    func configureFilm(_ film: Film) {
        activityIndicator.startAnimating()
        setupWithoutPositionImage()
        
        loadImageTask = Task {
            do {
                let image = try await ImageService.downloadImage(from: film.poster.image)
                if !Task.isCancelled {
                    activityIndicator.stopAnimating()
                    filmPoster.image = image
                }
            } catch {
                if !Task.isCancelled {
                    self.activityIndicator.stopAnimating()
                    filmPoster.image = UIImage(named: "photo")
                }
            }
        }
    }
    
    func configureFilm(with film: Film, at position: Int, shouldBeWithFilmPositionImage: Bool, didAlreadyLoadData: Bool) {
        activityIndicator.startAnimating()
        
        if shouldBeWithFilmPositionImage {
            setupWithPositionImage()
            filmPosition.image = UIImage(named: "\(position)")
        } else {
            setupWithoutPositionImage()
        }
        
        loadImageTask = Task {
            if didAlreadyLoadData {
                if let imageData = Data(base64Encoded: film.poster.image) {
                    let image = UIImage(data: imageData)
                    if !Task.isCancelled {
                        activityIndicator.stopAnimating()
                        filmPoster.image = image
                    }
                }
            } else {
                do {
                    let image = try await ImageService.downloadImage(from: film.poster.image)
                    if !Task.isCancelled {
                        activityIndicator.stopAnimating()
                        filmPoster.image = image
                    }
                } catch {
                    if !Task.isCancelled {
                        self.activityIndicator.stopAnimating()
                        filmPoster.image = UIImage(named: "photo")
                    }
                }
            }
        }
    }
    
    private func setupWithPositionImage() {
        addSubview(activityIndicator)
        addSubview(filmPoster)
        addSubview(filmPosition)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            filmPoster.topAnchor.constraint(equalTo: self.topAnchor),
            filmPoster.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SpacingConstants.medium),
            filmPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SpacingConstants.medium),
            filmPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            filmPosition.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SpacingConstants.tiny),
            filmPosition.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -SpacingConstants.tiny),
        ])
    }
    
    private func setupWithoutPositionImage() {
        addSubview(filmPoster)
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            filmPoster.topAnchor.constraint(equalTo: self.topAnchor),
            filmPoster.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            filmPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filmPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

