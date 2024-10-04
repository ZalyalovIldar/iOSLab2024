//
//  AvatarTableViewCell.swift
//  Profiler
//
//  Created by Тимур Салахиев on 30.09.2024.
//

import UIKit

class AvatarTableViewCell: UITableViewCell {
    
    var user: User = User(avatar: UIImage(named: "avatar")!,
                          fullName: "Salakhiev Timur Airatovich",
                          age: 19,
                          city: "Kazan",
                          workingExperience: 1,
                          photos: [
                             UIImage(named: "photo_1")!,
                             UIImage(named: "photo_2")!,
                             UIImage(named: "photo_3")!,
                             UIImage(named: "photo_4")!
                          ]
                     )
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = user.avatar
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
    
    private func setupLayout(){
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 200),
            avatarImageView.heightAnchor.constraint(equalToConstant: 200),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor)
        ])
    }
    

}

