//
//  InfoTableViewCell.swift
//  Homework
//
//  Created by Anna on 01.10.2024.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    
    func configure(with user: User) {
        nameLabel.text = user.name
        ageLabel.text = user.age
        cityLabel.text = user.city
    }
    
}

extension InfoTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

