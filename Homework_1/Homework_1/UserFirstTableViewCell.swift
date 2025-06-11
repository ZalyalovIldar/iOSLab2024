//
//  UserFirstTableViewCell 2.swift
//  Homework_1
//
//  Created by Дмитрий Леонтьев on 04.10.2024.
//


//
//  UserFirstTableViewCell.swift
//  Homework_1
//
//  Created by Дмитрий Леонтьев on 02.10.2024.
//

import UIKit

class UserFirstTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var cityOfResidence: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var FIO: UILabel!
    @IBOutlet weak var stackAboutMe: UIStackView!
    
    static let identifier: String = "UserFirstTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayout()
        setUp()
    }
    
    func configureCell(with user: User){
        avatar.image = user.avatar
        FIO.text = user.FIO
        age.text = user.age + " лет"
        cityOfResidence.text = user.cityOfResidence
    }
    
    private func setUp(){
        firstTitle.text = "О себе"
        firstTitle.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        
        FIO.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
    }
    
    private func setUpLayout(){
        avatar.translatesAutoresizingMaskIntoConstraints = false
        stackAboutMe.translatesAutoresizingMaskIntoConstraints = false
        firstTitle.translatesAutoresizingMaskIntoConstraints = false
        
        stackAboutMe.alignment = .center

        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 180),
            avatar.heightAnchor.constraint(equalToConstant: 180),
            
            firstTitle.topAnchor.constraint(equalTo: avatar.bottomAnchor),
            firstTitle.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),

            stackAboutMe.topAnchor.constraint(equalTo: firstTitle.bottomAnchor),
            stackAboutMe.centerXAnchor.constraint(equalTo: firstTitle.centerXAnchor),
            stackAboutMe.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)

        ])
    }
}
