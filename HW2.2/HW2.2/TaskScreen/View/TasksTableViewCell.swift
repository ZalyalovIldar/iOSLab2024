//
//  TasksTableViewCell.swift
//  HW2.2
//
//  Created by Павел on 10.04.2025.
//

import UIKit

final class TasksTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var taskStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskLabel, dateLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    private func setupUI() {
        contentView.addSubview(taskStack)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            taskStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            taskStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            taskStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            taskStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupCompletedCells(with task: TaskItem) {
        if task.isCompleted {
            let text = NSAttributedString(string: taskLabel.text ?? "", attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.lightGray,
            ])
            taskLabel.attributedText = text
            taskLabel.textColor = UIColor.lightGray
            
        } else {
            let text = NSAttributedString(string: taskLabel.text ?? "", attributes: [
                .strikethroughColor: UIColor.clear,
            ])
            taskLabel.textColor = .black
            taskLabel.attributedText = text
        }
    }
    
    func configureCell(with task: TaskItem) {
        taskLabel.text = task.task
        dateLabel.text = task.date.formatted(date: .abbreviated, time: .shortened)
    }
    
}

extension TasksTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
}
