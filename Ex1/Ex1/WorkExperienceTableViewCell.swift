//
//  WorkExperienceTableViewCell.swift
//  Ex1
//
//  Created by Терёхин Иван on 04.10.2024.
//

import UIKit

class WorkExperienceTableViewCell: UITableViewCell {

    lazy var experienceDescription: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        
        return label
    }()
    
    
    func setupLayout(){
        contentView.addSubview(experienceDescription)
        
        NSLayoutConstraint.activate([
            experienceDescription.topAnchor.constraint(equalTo: contentView.topAnchor),
            experienceDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            experienceDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            experienceDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        
        ])
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: Profile){
        experienceDescription.text = user.workExperience
        
    }
    
    
}
extension WorkExperienceTableViewCell {
    
    static var reuseIndentifier: String {
        return String(describing: self)
    }
}
