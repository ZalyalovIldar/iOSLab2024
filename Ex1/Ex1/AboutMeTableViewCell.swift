//
//  AboutMeTableViewCell.swift
//  Ex1
//
//  Created by Терёхин Иван on 04.10.2024.
//

import UIKit

class AboutMeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stack: UIStackView!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var age: UILabel!

    
    
    func configure(with profile: Profile) {
        
    
                
        fullName.text = "ФИО: \(profile.fullName)"
        city.text = "Город: \(profile.city)"
        age.text = "Возраст: \(profile.age)"
    }
}



extension AboutMeTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
