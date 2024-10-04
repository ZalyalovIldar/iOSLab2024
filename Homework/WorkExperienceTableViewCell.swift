//
//  WorkExperienceTableViewCell.swift
//  Homework
//
//  Created by Anna on 01.10.2024.
//

import Foundation
import UIKit

class WorkExperienceTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Годы и опыт работы"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var workExperienceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(workExperienceLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            workExperienceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            workExperienceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            workExperienceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            workExperienceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20 )
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        workExperienceLabel.text = user.workExperience
    }

}
extension WorkExperienceTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
