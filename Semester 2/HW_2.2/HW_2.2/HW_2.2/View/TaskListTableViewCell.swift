//
//  TaskListTableViewCell.swift
//  HW_2.2
//
//  Created by Павел Калинин on 07.04.2025.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
        
    lazy var doneImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(doneImage)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            doneImage.widthAnchor.constraint(equalToConstant: 25),
            doneImage.heightAnchor.constraint(equalToConstant: 25),
            doneImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            doneImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            titleLabel.leadingAnchor.constraint(equalTo: doneImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with taskItem: TaskItem) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if taskItem.isCompleted {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let attributedString = NSAttributedString(string: taskItem.title, attributes: attributes)
        titleLabel.attributedText = attributedString
        
        doneImage.image = taskItem.isCompleted ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
}

extension TaskListTableViewCell {
    static let reuseIdentifier = "TaskListTableViewCell"
}
