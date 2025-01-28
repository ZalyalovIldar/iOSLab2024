//
//  FilmImageCollectionViewCell.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

import UIKit

class MovieSnapsCollectionViewCell: UICollectionViewCell {
    
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
        return image
    }()
    
    func setupWithImage(_ image: String) {
        filmImage.image = nil
        
        loadingIndicator.startAnimating()
        Task {
            do {
                let image = try await ImageService.downloadImage(from: image)
                filmImage.image = image
                loadingIndicator.stopAnimating()
            } catch {
                print("Error of loading image on film: \(error.localizedDescription)")
                loadingIndicator.stopAnimating()
                filmImage.image = .failToLoad
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(loadingIndicator)
        addSubview(filmImage)
    
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

extension MovieSnapsCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}
