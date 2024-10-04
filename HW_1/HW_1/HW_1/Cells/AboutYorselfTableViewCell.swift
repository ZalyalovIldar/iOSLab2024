//
//  CustomTableViewCell.swift
//  HW_1
//
//  Created by Damir Rakhmatullin on 2.10.24.
//

import UIKit

class AboutYourselfTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    

    func configure(name: String, age: String, city: String) {
        nameLable.text = "ФИО: \(name)"
        ageLable.text = "Возраст: \(age)"
        cityLabel.text = "Город проживания: \(city)"
    }
    
}


        
extension AboutYourselfTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
        
        // Configure the view for the selected state
