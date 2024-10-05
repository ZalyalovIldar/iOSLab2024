//
//  CustomClassExperience.swift
//  homework1
//
//  Created by Лидия  on 05.10.2024.
//

import UIKit
class ExperienceCell: UITableViewCell {
    static let reuseIdentifier = "ExperienceCell"
    
    let experienceLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        experienceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        experienceLabel.numberOfLines = 1
        experienceLabel.textAlignment = .center
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
      
        contentView.addSubview(experienceLabel)
        contentView.addSubview(descriptionLabel)
        
        experienceLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            experienceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            experienceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            experienceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            descriptionLabel.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
