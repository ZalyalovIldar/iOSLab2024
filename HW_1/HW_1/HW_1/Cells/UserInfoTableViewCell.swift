//
//  TableViewCell.swift
//  HW_1
//
//  Created by Павел Калинин on 21.09.2024.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    func configure(with user: User) {
        nameLabel.text = user.name
        ageLabel.text = String(describing: user.age)
        cityLabel.text = user.city
    }
}
