import UIKit

class TopMoviesCollectionViewCell: UICollectionViewCell {
    
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
    
    private lazy var poster: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Constant.imageCornerRadius
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var numberImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private func setupLayout() {
        contentView.addSubview(poster)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(numberImage)
    
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Padding.medium),
            poster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Padding.medium),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Padding.medium),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            numberImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constant.Padding.small),
            numberImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.Padding.tiny),
        ])
    }
    
    func configure(movie: Movie, at indexNumber: Int) {
        loadingIndicator.startAnimating()
        imageTask = Task {
            do {
                let image = try await ImageService.downloadImage(by: movie.poster.image)
                if !Task.isCancelled {
                    loadingIndicator.stopAnimating()
                    poster.image = image
                }
            }
            catch {
                poster.image = .notFound
                print("Erorr obtain image: \(error)")
            }
        }
        numberImage.image = UIImage(named: "number-\(indexNumber)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        poster.image = nil
        imageTask?.cancel()
    }
}

extension TopMoviesCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
