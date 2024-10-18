//
//  WorkExperienceTableViewCell.swift
//  HW_1
//
//  Created by Damir Rakhmatullin on 4.10.24.
//

import UIKit

class WorkExperienceTableViewCell: UITableViewCell {
    
    lazy var yearLabel: UILabel = {
        let year = UILabel()
        year.translatesAutoresizingMaskIntoConstraints = false
        year.textAlignment = .center
        year.numberOfLines = 0
        
        return year
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textAlignment = .left
        description.numberOfLines = 0
        
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(year: String, description: String) {
        yearLabel.text = year
        descriptionLabel.text = description
    }

    
    func setupLayout() {
        let stackview = UIStackView(arrangedSubviews: [yearLabel, descriptionLabel])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.spacing = 10
        
        contentView.addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
       
    }
}
extension WorkExperienceTableViewCell {
    static var reuseIdentifier: String {
         return String(describing: self)
     }
}
