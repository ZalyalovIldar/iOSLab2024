//
//  FirstSectionTableViewCell.swift
//  UserSummary
//
//  Created by Тагир Файрушин on 26.09.2024.
//

import UIKit

class FirstSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleUserInfoLabel: UILabel!
    
    @IBOutlet weak var stackUserInfoView: UIStackView!
    
    @IBOutlet weak var titleUserFullNameLabel: UILabel!
    
    @IBOutlet weak var titleUserAgeLabel: UILabel!
    
    @IBOutlet weak var titleUserCurrentPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleUserFullNameLabel.numberOfLines = 1
        titleUserAgeLabel.numberOfLines = 1
        titleUserCurrentPlaceLabel.numberOfLines = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // This method configures a table view cell to display user information
    // It sets the text and style for the labels including the user's full name, age, and current place
    // of residence, along with a general info section title
    func configurateCell(with user: User){
        titleUserInfoLabel.text = "О себе"
        titleUserInfoLabel.font  = UIFont.boldSystemFont(ofSize: 18)
        titleUserInfoLabel.textAlignment = .center
        titleUserFullNameLabel.text = "ФИО: \(user.fullName)"
        titleUserAgeLabel.text = "Возраст: \(user.age) лет"
        titleUserCurrentPlaceLabel.text = "Город проживания: \(user.currentPlace)"
    }
}

extension FirstSectionTableViewCell{
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
