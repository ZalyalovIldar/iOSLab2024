//
//  UserSecondTableViewCell.swift
//  Homework_1
//
//  Created by Дмитрий Леонтьев on 02.10.2024.
//

import UIKit

class UserSecondTableViewCell: UITableViewCell {
    
    static let identifier: String = "UserSecondTableViewCell"

    private lazy var secondTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var workExperience: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    func configureCell(with user: User){
        workExperience.text = user.workExperience + ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        contentView.addSubview(secondTitle)
        contentView.addSubview(workExperience)
        
        secondTitle.text = "Опыт работы"
        secondTitle.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        
        workExperience.numberOfLines = 0
        
    }
    
    private func setUpLayout(){
        secondTitle.translatesAutoresizingMaskIntoConstraints = false
        workExperience.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            secondTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            workExperience.topAnchor.constraint(equalTo: secondTitle.bottomAnchor),
            workExperience.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            workExperience.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            workExperience.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),

        ])
    }

}
