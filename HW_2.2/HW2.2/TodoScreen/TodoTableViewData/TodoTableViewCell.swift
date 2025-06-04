//
//  TodoTableViewCell.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(self)" }
    
    private lazy var todoTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: FontConstants.title.value)
        return label
    }()
    
    private lazy var finishedView: UIImageView = {
        let image = SystemImages.square.image
        let imageView = UIImageView(image: image)
        imageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        return imageView
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            finishedView,
            todoTitle
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Padding.default.value
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ todo: Todo) {
        todoTitle.text = todo.title
    }
}

private extension TodoTableViewCell {
    
    func setup() {
        self.selectionStyle = .none
        setupLayout()
        setupContraints()
    }
    
    func setupLayout() {
        addSubview(dataStackView)
    }
    
    func setupContraints() {
        dataStackView.edges(to: contentView, padding: Padding.default.value)
    }
}

