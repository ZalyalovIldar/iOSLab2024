//
//  TodoView.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

final class TodoView: UIView {
    
    private(set) lazy var todoTableView: UITableView = {
        let bgLable = UILabel()
        bgLable.textColor = .secondaryLabel
        bgLable.font = .systemFont(ofSize: FontConstants.title.value)
        bgLable.text = "Nothing to do, nice!"
        bgLable.textAlignment = .center

        let table = UITableView()
        table.backgroundView = bgLable
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        return table
    }()
    
    private(set) lazy var createTodoButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = UIElementsSize.addTodoButton.getCircledCR
        let buttonImageView = UIImageView(image: SystemImages.addTodo.image)
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(buttonImageView)
        buttonImageView.edges(to: button, padding: 0)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotateButton(_ isEnabled: Bool) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
            self.createTodoButton.transform = isEnabled ? .identity : CGAffineTransform(rotationAngle: .pi / 4)
        }
    }
}

private extension TodoView {
    
    enum UIElementsSize: CGFloat {
        case addTodoButton = 50
        var getCircledCR: CGFloat {
            self.rawValue / 2
        }
    }
    
    func setup() {
        self.backgroundColor = .systemBackground
        setupLayout()
        setupContraints()
    }
    
    func setupLayout() {
        addSubview(todoTableView)
        addSubview(createTodoButton)
    }
    
    func setupContraints() {
        todoTableView.edges(to: self, padding: Padding.tiny.value)
        
        NSLayoutConstraint.activate([
            createTodoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createTodoButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Padding.default.value),
            createTodoButton.heightAnchor.constraint(equalToConstant: UIElementsSize.addTodoButton.rawValue),
            createTodoButton.widthAnchor.constraint(equalTo: createTodoButton.heightAnchor),
        ])
    }
}

