import UIKit

class AddPictureCell: UICollectionViewCell {
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addPictureAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addButton)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .gray
        addButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 150),
            addButton.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func addPhotoTapped() {
        addPictureAction?()
    }

}
