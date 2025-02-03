import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private var loadImageTask: Task<Void, Never>?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemGray6
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.tiny
        return image
    }()
    
    private lazy var moviePosition: UIImageView = {
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
        movieImage.image = nil
    }
    
    func configureTopMovie(_ movie: Movie, at position: Int, didLoadData: Bool) {
        loadingIndicator.startAnimating()
        moviePosition.image = UIImage(named: "\(position)")
        
        setupWithPositionImage()
        
        loadImageTask = Task {
            if didLoadData {
                if let imageData = Data(base64Encoded: movie.poster.image), let image = UIImage(data: imageData) {
                    if !Task.isCancelled {
                        loadingIndicator.stopAnimating()
                        movieImage.image = image
                    }
                }
            } else {
                do {
                    let image = try await ImageService.downloadImage(from: movie.poster.image)
                    if !Task.isCancelled {
                        loadingIndicator.stopAnimating()
                        movieImage.image = image
                    }
                } catch {
                    if !Task.isCancelled {
                        self.loadingIndicator.stopAnimating()
                        self.movieImage.image = .failToLoad
                    }
                }
            }
        }
    }
    
    func configureMovie(_ movie: Movie) {
        loadingIndicator.startAnimating()
        setupWithoutPositionImage()
        
        loadImageTask = Task {
            do {
                let image = try await ImageService.downloadImage(from: movie.poster.image)
                if !Task.isCancelled {
                    loadingIndicator.stopAnimating()
                    movieImage.image = image
                }
            } catch {
                if !Task.isCancelled {
                    self.loadingIndicator.stopAnimating()
                    self.movieImage.image = .failToLoad
                }
            }
        }
    }
    
    private func setupWithPositionImage() {
        addSubview(loadingIndicator)
        addSubview(movieImage)
        addSubview(moviePosition)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            movieImage.topAnchor.constraint(equalTo: self.topAnchor),
            movieImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.small),
            movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.small),
            movieImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            moviePosition.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.nothing),
            moviePosition.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -Constants.ultraTiny),
        ])
    }
    
    private func setupWithoutPositionImage() {
        addSubview(loadingIndicator)
        addSubview(movieImage)
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            movieImage.topAnchor.constraint(equalTo: self.topAnchor),
            movieImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

extension MovieCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}

