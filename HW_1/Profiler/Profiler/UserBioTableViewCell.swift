//
//  UserBioTableViewCell.swift
//  Profiler
//
//  Created by Тимур Салахиев on 03.10.2024.
//

import UIKit

class UserBioTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = user.fullName
        ageLabel.text = String(user.age)
        cityLabel.text = user.city
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

