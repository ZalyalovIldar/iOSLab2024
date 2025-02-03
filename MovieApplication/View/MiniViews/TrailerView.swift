import UIKit

class TrailerView: UIView {
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: Fonts.tiny)
        label.textColor = .white
        label.text = "Трейлер"
        return label
    }()
    
    private lazy var playView: UIImageView = {
        let play = UIImageView(image: UIImage(systemName: "play.rectangle.fill"))
        play.tintColor = .white
        play.translatesAutoresizingMaskIntoConstraints = false
        return play
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            title,
            playView
        ])
        stack.axis = .horizontal
        stack.spacing = Constants.nothing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.ultraTiny
        view.clipsToBounds = true
        view.backgroundColor = Colors.mildPink
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(backgroundView)
        backgroundView.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Constants.nothing),
            dataStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Constants.nothing),
            dataStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Constants.nothing),
            dataStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Constants.nothing),
        ])
    }
}

