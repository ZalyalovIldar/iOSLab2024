//
//  UserTableViewCell.swift
//  HW1
//
//  Created by дилара  on 04.10.2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var avatarImage: UIImageView!
    func configure (with user: User) {
        nameLabel.text = user.name
        ageLabel.text = "\(user.age)" + "yo"
        cityLabel.text = user.city
    }
    

}
