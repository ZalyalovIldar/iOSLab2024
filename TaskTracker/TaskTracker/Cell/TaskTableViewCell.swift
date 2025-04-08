//
//  TaskTableViewCell.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    private enum Constraints: CGFloat {
        case verticalPadding = 10
        case horizontalPadding = 15
    }
    
    private lazy var taskText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(text: String) {
        taskText.text = text
    }
    
    private func setupSubviews() {
        contentView.addSubview(taskText)
    }
    
    private func setupLayout() {
        let bottomConstraint = taskText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.verticalPadding.rawValue)
        bottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            taskText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraints.verticalPadding.rawValue),
            taskText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.horizontalPadding.rawValue),
            taskText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.horizontalPadding.rawValue),
            bottomConstraint
        ])
    }
}

extension TaskTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
