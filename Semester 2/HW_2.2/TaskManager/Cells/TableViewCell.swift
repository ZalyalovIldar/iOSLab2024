//
//  TableViewCell.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 7.04.25.
//

import UIKit


class TableViewCell: UITableViewCell {
    
     lazy var noteDescription: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var checkBoxIsDone: UIButton = {
        let checkBox = UIButton(type: .system)
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.tintColor = .systemBlue
        checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return checkBox
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with note: TaskItem) {
        noteDescription.text = note.description
        
        let imageName = note.isDone ? "checkmark.square.fill" : "square"
        checkBoxIsDone.setImage(UIImage(systemName: imageName), for: .normal)
    
    }
    
    func setupView() {
        let stackView = UIStackView(arrangedSubviews: [checkBoxIsDone, noteDescription])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension TableViewCell {
    static var reuseIdentifier: String {
           return String(describing: type(of: self))
    }
}
