//
//  ListTaskTableViewCell.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import UIKit

class ListTaskTableViewCell: UITableViewCell {
    private lazy var titleTaskLabel = Label(numberOfLinesLabel: 1, sizeFont: 24, fontWeight: .medium)
    
    private lazy var descriptionTaskLabel = Label(numberOfLinesLabel: 0, sizeFont: 16,
                                             fontWeight: .light)
    
    private lazy var dateLabel = Label(numberOfLinesLabel: 1, sizeFont: 10, fontWeight: .thin)
    
    private lazy var dateAndTitleStack = StackView(views: [titleTaskLabel, dateLabel],
                                                   stackAxis: .horizontal, stackAligment: .leading)
    private lazy var mainStack = StackView(views: [dateAndTitleStack, descriptionTaskLabel],
                                           stackAxis: .vertical)
    
    var didPressButton: ((Bool) -> Void)?
    
    private lazy var complButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.complButton.isSelected.toggle()
            didPressButton?(complButton.isSelected)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.99, alpha: 1)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubviews(mainStack, complButton)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: complButton.trailingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            complButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            complButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            complButton.widthAnchor.constraint(equalToConstant: 24),
            complButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func configureCell(task: TaskItem) {
        titleTaskLabel.text = task.title
        descriptionTaskLabel.text = task.taskDescription
        dateLabel.text = FormattedDate.formated(date: task.date)
        complButton.isSelected = task.isCompleted
    }
}

extension ListTaskTableViewCell {
    static var reuseIndentifier: String {
        return "\(self)"
    }
}
