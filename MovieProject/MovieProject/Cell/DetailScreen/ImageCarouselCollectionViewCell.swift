import UIKit

class ImageCarouselCollectionViewCell: UICollectionViewCell {
    private var imageTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mainImages: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = Constant.DetailView.mainImagesCornerRadius
        return image
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatior = UIActivityIndicatorView(style: .large)
        indicatior.translatesAutoresizingMaskIntoConstraints = false
        indicatior.color = .systemGray6
        indicatior.hidesWhenStopped = true
        return indicatior
    }()
    
    private func setupLayout() {
        contentView.addSubview(mainImages)
        contentView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            mainImages.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImages.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImages.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImages.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configure(images: Images) {
        loadingIndicator.startAnimating()
        let firstImageURL = images.image
        imageTask = Task {
            do {
                let downloadImage = try await ImageService.downloadImage(by: firstImageURL)
                self.mainImages.image = downloadImage
                loadingIndicator.stopAnimating()
                
            } catch {
                mainImages.image = .notFound
                print("Failed to load image: \(error)")
            }
        }
    }

    override func prepareForReuse() {
    super.prepareForReuse()
    mainImages.image = nil
    imageTask?.cancel()
    }
}

extension ImageCarouselCollectionViewCell {
    static var reuseIndetifier: String {
        return String(describing: self)
    }
}
