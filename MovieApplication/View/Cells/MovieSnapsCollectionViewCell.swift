import UIKit

class MovieSnapsCollectionViewCell: UICollectionViewCell {
    
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
        return image
    }()
    
    func setupWithImage(_ image: String) {
        movieImage.image = nil
        
        loadingIndicator.startAnimating()
        Task {
            do {
                let image = try await ImageService.downloadImage(from: image)
                movieImage.image = image
                loadingIndicator.stopAnimating()
            } catch {
                print("Error of loading image on film: \(error.localizedDescription)")
                loadingIndicator.stopAnimating()
                movieImage.image = .failToLoad
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
        addSubview(movieImage)
    
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

extension MovieSnapsCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}

