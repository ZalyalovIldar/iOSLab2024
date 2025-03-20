import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    private var imageTask: Task<Void, Never>?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatior = UIActivityIndicatorView(style: .large)
        indicatior.translatesAutoresizingMaskIntoConstraints = false
        indicatior.color = .systemGray6
        indicatior.hidesWhenStopped = true
        return indicatior
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Constant.imageCornerRadius
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    func configureCell(with movie: Movie) {
        loadingIndicator.startAnimating()
        imageTask = Task {
            do {
                let image = try await ImageService.downloadImage(by: movie.poster.image)
                if !Task.isCancelled {
                    loadingIndicator.stopAnimating()
                    movieImage.image = image
                }
            } catch {
                movieImage.image = .notFound
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        imageTask?.cancel()
    }
    
    private func setupLayout() {
        contentView.addSubview(movieImage)
        contentView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
        movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Padding.small),
        movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constant.Padding.small),
        
        loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

extension MoviesCollectionViewCell {
    static var reuseIndentifier: String  {
        return String(describing: self)
    }
}
