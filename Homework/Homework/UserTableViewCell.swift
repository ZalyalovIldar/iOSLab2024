//
//  UserTableViewCell.swift
//  Homework
//
//  Created by Павел on 27.09.2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameUILabel: UILabel!
    @IBOutlet weak var ageUILabel: UILabel!
    @IBOutlet weak var cityUILabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with user: User) {
        nameUILabel.text = "\(user.surname) \(user.name) \(user.patronymic)"
        ageUILabel.text = "\(user.age) лет"
        cityUILabel.text = user.city
    }
}

extension UserTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
