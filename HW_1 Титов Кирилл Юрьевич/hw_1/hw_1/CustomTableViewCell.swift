//
//  CustomTableViewCell.swift
//  hw_1
//
//  Created by Кирилл Титов on 01.10.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var age: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


