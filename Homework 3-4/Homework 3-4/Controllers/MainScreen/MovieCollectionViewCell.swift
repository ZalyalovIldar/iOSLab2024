import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let numberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(numberImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            numberImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            numberImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -21),
            numberImageView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.45),
            numberImageView.heightAnchor.constraint(equalTo: numberImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Film, rank: Int?) {
        titleLabel.text = movie.title
        
        if let imageURLString = movie.poster?.image,
           let imageURL = URL(string: imageURLString),
           imageURLString != "default" {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "default")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            imageView.image = UIImage(named: "default")
        }
        
        if let rank = rank, rank >= 1, rank <= 10 {
            numberImageView.image = UIImage(named: "\(rank)")
            numberImageView.isHidden = false
        } else {
            numberImageView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "default")
        titleLabel.text = nil
        numberImageView.image = nil
        numberImageView.isHidden = true
    }
    
    func animateAppearance(delay: TimeInterval = 0) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: [.curveEaseOut],
                       animations: {
                           self.alpha = 1
                           self.transform = .identity
                       },
                       completion: nil)
    }
}


