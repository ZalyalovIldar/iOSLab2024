//
//  AvatarHeaderTableViewCell.swift
//  homeWork1
//
//  Created by Данил Забинский on 26.09.2024.
//

import UIKit

class AvatarHeaderTableViewCell: UITableViewCell {
    // MARK: - Properties
    private lazy var avatarImage: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 100
        avatar.contentMode = .scaleAspectFill
        avatar.layer.masksToBounds = true
        avatar.backgroundColor = .white
        return avatar
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configureWithUser(from user: User) {
        avatarImage.image = user.avatarImage
    }
    
    // MARK: - Private Layout Setup
    private func setupLayout() {
        guard avatarImage.superview == nil else { return }
        
        contentView.addSubview(avatarImage)
        
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 200),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            avatarImage.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

}

// MARK: - Identifier Extension
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

