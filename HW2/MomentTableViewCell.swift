import Foundation
import UIKit

class MomentTableViewCell: UITableViewCell {
    private var images: [UIImage] = []
    private let maxPhotoCount = 2
    private let maxLineCount = 5
    
    lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(photosStack)
        stack.addArrangedSubview(descriptionStack)
        return stack
    }()
    
    lazy var photosStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = maxLineCount
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    lazy var descriptionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateLabel)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentStack)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }
    
    private func setupStackView() {
        photosStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем изображения в imagesStack
        for i in 0..<min(images.count, maxPhotoCount) {
            let imageView = createImageView(with: images[i])
            photosStack.addArrangedSubview(imageView)
        }
        
        // Настройка высоты imagesStack
        photosStack.isHidden = images.isEmpty
        photosStack.heightAnchor.constraint(equalToConstant: images.isEmpty ? 0 : 150).isActive = true
    }
    
    private func createImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }
    
    func configure(with moment: Moment) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        descriptionLabel.text = moment.description
        dateLabel.text = formatter.string(from: moment.date)
        images = moment.images
        
        setupStackView()
    }
}

extension MomentTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
