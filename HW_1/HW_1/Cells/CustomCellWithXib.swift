//
//  CustomCellWithXib.swift
//  HW_1
//
//  Created by Ильнур Салахов on 02.10.2024.
//

import UIKit

class CustomCellWithXib: UITableViewCell {
    
    @IBOutlet weak var labelOfXibCell: UILabel!
    
    @IBOutlet weak var currentPlaceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    func configure(with user: User) {
        fullNameLabel.text = "ФИО: \(user.fullName)"
        ageLabel.text = "Возраст: \(user.age) лет"
        currentPlaceLabel.text = "Город проживания: \(user.currentPlace)"

    }
}
