//
//  ExperienceTableViewCell.swift
//  HW1
//
//  Created by дилара  on 04.10.2024.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    private let yearLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        let stackView = UIStackView(arrangedSubviews: [yearLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        descriptionLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

    }
        
    func configure(with experience: Experience) {
            yearLabel.text = experience.year
            descriptionLabel.text = experience.description
        }
}


