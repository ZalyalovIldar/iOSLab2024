//
//  UsersCollectionViewCell.swift
//  CocoaPodsHW
//
//  Created by Павел on 21.03.2025.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private lazy var userStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, emailLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    

    
    private func setupUI() {
        contentView.addSubview(userStackView)
        
        NSLayoutConstraint.activate([
            userStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell(with user: User) {
        nameLabel.text = user.name
        usernameLabel.text = user.username
        emailLabel.text = user.email
    }
    
}

extension UsersCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
