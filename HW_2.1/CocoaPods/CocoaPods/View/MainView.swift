import UIKit

protocol changePhotoDelegate: AnyObject {
    func changePhoto() async -> Data
}

class MainView: UIView {
    
    weak var changePhotoDelegate: changePhotoDelegate?
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var button: UIButton = {
        var action = UIAction { _ in
            Task {
                if let data = await self.changePhotoDelegate?.changePhoto(), !data.isEmpty {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                } else {
                    print("Failed to load image data.")
                }
            }
        }
        
        var button = UIButton(type: .system, primaryAction: action)
        button.setTitle("get random fox photo".capitalized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
