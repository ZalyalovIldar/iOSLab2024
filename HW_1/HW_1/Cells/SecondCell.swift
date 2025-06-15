//
//  SecondCell.swift
//  HW_1
//
//  Created by Ильнур Салахов on 03.10.2024.
//

import UIKit

class SecondCell: UITableViewCell {

    
    lazy var expirienceTitleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.text = "Опыт работы"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    
    lazy var workExpierienceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(expirienceTitleLabel)
            contentView.addSubview(workExpierienceLabel)
            setupCell()

        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func setupCell() {
        NSLayoutConstraint.activate([
            expirienceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            expirienceTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            workExpierienceLabel.topAnchor.constraint(equalTo: expirienceTitleLabel.bottomAnchor,constant: 30),
            workExpierienceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            workExpierienceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10)
        ])
    }
    
    func configure(with user: User) {
        workExpierienceLabel.text = user.workExpierience
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
