//
//  ExperienceTableViewCell.swift
//  Homework
//
//  Created by Павел on 30.09.2024.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyExperienceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(experience: Experience) {
        yearLabel.text = "\(experience.year) год"
        companyExperienceLabel.text = experience.description
    }
    
    private func setupUI() {
        yearLabel.font = UIFont(name: "Gill Sans", size: 17)
        companyExperienceLabel.font = UIFont(name: yearLabel.font.fontName, size: yearLabel.font.pointSize)
    }
    
    private func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [yearLabel, companyExperienceLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
    
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            yearLabel.widthAnchor.constraint(equalToConstant: 72),
            yearLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            companyExperienceLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 10),
            companyExperienceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ExperienceTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
