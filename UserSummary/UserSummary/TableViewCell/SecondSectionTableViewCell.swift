//
//  SecondSectionTableViewCell.swift
//  UserSummary
//
//  Created by Тагир Файрушин on 27.09.2024.
//

import UIKit

class SecondSectionTableViewCell: UITableViewCell {

    lazy var titleHeaderInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Опыт работы"
        return label
    }()
    
    lazy var titleJobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleHeaderInfoLabel)
        contentView.addSubview(titleJobDescriptionLabel)
        setupLayot()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayot() {
        NSLayoutConstraint.activate([
            titleHeaderInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titleHeaderInfoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleJobDescriptionLabel.topAnchor.constraint(equalTo: titleHeaderInfoLabel.bottomAnchor, constant: 20),
            titleJobDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleJobDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleJobDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20 )
        ])
    }
    
    // This method configures the cell to display the user's job description
    func configureCell(with user: User) {
        titleJobDescriptionLabel.text = user.descriptionJob
    }
}

extension SecondSectionTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
