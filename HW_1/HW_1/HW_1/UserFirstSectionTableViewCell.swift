//
//  UserFirstSectionTableViewCell.swift
//  HW_1
//
//  Created by Артур Мавликаев on 02.10.2024.
//

import UIKit

class UserFirstSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var FIO: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var age: UILabel!
    static let identifier = "UserFirstSectionTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        setupAvatar()
        setupLabelText()
        setupConstraints()
    }
    
    private func setupAvatar() {
        avatar.image = UIImage(named: "1")
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        
    }
    private func setupLabelText() {
        FIO.text = "Настенька Шибанова"
        city.text = "Москва"
        age.text = "19"
        FIO.font = UIFont.boldSystemFont(ofSize: 22)
        city.font = UIFont.systemFont(ofSize: 20)
        age.font = UIFont.systemFont(ofSize: 20)
    }
    private func setupConstraints() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        FIO.translatesAutoresizingMaskIntoConstraints = false
        city.translatesAutoresizingMaskIntoConstraints = false
        age.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            avatar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),

           
            FIO.topAnchor.constraint(equalTo: avatar.bottomAnchor),
            FIO.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            FIO.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            FIO.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            
            city.topAnchor.constraint(equalTo: FIO.bottomAnchor),
            city.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            city.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            city.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            age.topAnchor.constraint(equalTo: city.bottomAnchor),
            age.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            age.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            age.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            age.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
    }
    
}
