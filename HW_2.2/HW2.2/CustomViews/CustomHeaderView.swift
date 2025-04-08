//
//  CustomHeaderView.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

final class CustomHeaderView: UIView {
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: FontConstants.header.value)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    init(label: String) {
        super.init(frame: .zero)
        title.text = label
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomHeaderView {
    
    func setup() {
        self.backgroundColor = .systemBackground
        setupLayout()
        setupContraints()
    }
    
    func setupLayout() {
        addSubview(title)
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Padding.tiny.value),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
