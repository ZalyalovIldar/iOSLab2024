//
//  SecondTableViewCell.swift
//  homeWork1
//
//  Created by Данил Забинский on 24.09.2024.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var workDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configureWithUser(from user: User) {
        workDescriptionLabel.text = user.getExperienceSummary
    }
    
    // MARK: - Private Methods
    private func setUp() {
        setupAppearance()
        setupTitleLabelText()
        setupConstraints()
    }
    
    private func setupAppearance() {
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 25
    }
    
    private func setupTitleLabelText() {
        titleLabel.text = "Опыт работы"
    }
    
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(workDescriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            workDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            workDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            workDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            workDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}


