//
//  FirstSectionCell.swift
//  homework1
//
//  Created by Лидия  on 05.10.2024.
//

import UIKit

class FirstSectionCell: UITableViewCell {
    static let reuseIdentifier = "FirstSectionCell"
        
        let aboutMe = UILabel()
        let name = UILabel()
    let age = UILabel()
    let city = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        aboutMe.font = UIFont.boldSystemFont(ofSize: 20)
        aboutMe.numberOfLines = 1
        aboutMe.textAlignment = .center
        
        name.font = UIFont.systemFont(ofSize: 16)
        name.numberOfLines = 1
        age.font = UIFont.systemFont(ofSize: 16)
        age.numberOfLines = 1
        city.font = UIFont.systemFont(ofSize: 16)
        city.numberOfLines = 1
        contentView.addSubview(aboutMe)
        contentView.addSubview(name)
        contentView.addSubview(age)
        contentView.addSubview(city)
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        age.translatesAutoresizingMaskIntoConstraints = false
        city.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aboutMe.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            aboutMe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            aboutMe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            name.topAnchor.constraint(equalTo: aboutMe.bottomAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            age.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            age.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            age.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            city.topAnchor.constraint(equalTo: age.bottomAnchor, constant: 5),
            city.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            city.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            city.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    


}
