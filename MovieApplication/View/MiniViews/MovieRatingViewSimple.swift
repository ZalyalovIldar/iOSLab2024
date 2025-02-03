import UIKit

class MovieRatingViewSimple: UIView {
    
    private lazy var starView: UIImageView = {
        let star = UIImageView(image: UIImage(systemName: "star"))
        star.tintColor = .systemOrange
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }()
    
    private lazy var ratingTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: Fonts.tiny)
        return label
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            starView,
            ratingTitle
        ])
        stack.axis = .horizontal
        stack.spacing = Constants.nothing
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRating(rating: Double) {
        ratingTitle.text = "\(rating)"
    }
    
    private func setup() {

        addSubview(dataStackView)
        NSLayoutConstraint.activate([
            dataStackView.topAnchor.constraint(equalTo: self.topAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dataStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}


