import UIKit

class MovieRatingView: UIView {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.ultraTiny
        view.backgroundColor = Colors.dark
        return view
    }()
    
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
        label.font = UIFont(name: "Montserrat-Medium", size: Fonts.tiny)
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
        addSubview(backgroundView)
        backgroundView.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Constants.nothing),
            dataStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Constants.nothing),
            dataStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Constants.nothing),
            dataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.nothing)
        ])
    }
}
