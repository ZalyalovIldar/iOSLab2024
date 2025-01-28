import UIKit

protocol SlideViewDelegate: AnyObject {
    func nextImage()
    func previousImage()
}

class SlideView: UIView {

    private weak var delegate: SlideViewDelegate?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func createNavigationButton(imageName: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray6
        button.transform = CGAffineTransform(scaleX: 2, y: 2)
        button.addAction(UIAction { [weak self] _ in
            action()
        }, for: .touchUpInside)
        return button
    }

    private lazy var nextButton: UIButton = createNavigationButton(imageName: "chevron.forward.circle.fill") { [weak self] in
        self?.delegate?.nextImage()
    }

    private lazy var previousButton: UIButton = createNavigationButton(imageName: "chevron.backward.circle.fill") { [weak self] in
        self?.delegate?.previousImage()
    }

    private lazy var upperDismissButton: UIButton = createDismissButton()
    private lazy var lowerDismissButton: UIButton = createDismissButton()

    private func createDismissButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray6
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    func setDelegate(_ delegate: SlideViewDelegate) {
        self.delegate = delegate
    }
    
    func setDismissAction(_ dismissAction: UIAction) {
        upperDismissButton.addAction(dismissAction, for: .touchUpInside)
        lowerDismissButton.addAction(dismissAction, for: .touchUpInside)
    }
    
    func deactivateNavigationButtons() {
        nextButton.alpha = 0.25
        nextButton.isUserInteractionEnabled = false
        previousButton.alpha = 0.25
        previousButton.isUserInteractionEnabled = false
    }
    
    func setupWithImage(url: String) {
        loadingIndicator.startAnimating()
        Task {
            do {
                imageView.image = try await ImageService.downloadImage(from: url)
                loadingIndicator.stopAnimating()
            } catch {
                print("Error downloading image: \(error.localizedDescription)")
                imageView.image = .failToLoad
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = Colors.mainGray.withAlphaComponent(0.9)
        
        addSubview(upperDismissButton)
        addSubview(imageView)
        addSubview(nextButton)
        addSubview(previousButton)
        addSubview(loadingIndicator)
        addSubview(lowerDismissButton)
        
        NSLayoutConstraint.activate([

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.tiny),
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            previousButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.tiny),
            previousButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            upperDismissButton.topAnchor.constraint(equalTo: topAnchor),
            upperDismissButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            upperDismissButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            upperDismissButton.bottomAnchor.constraint(equalTo: imageView.topAnchor),
            
            lowerDismissButton.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            lowerDismissButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerDismissButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            lowerDismissButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
