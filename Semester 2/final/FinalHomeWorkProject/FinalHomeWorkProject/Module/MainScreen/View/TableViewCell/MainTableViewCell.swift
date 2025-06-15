//
//  MainTableViewCell.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import UIKit
import SnapKit

final class MainTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
        
    private lazy var iconContainer = UIView()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image?.withTintColor(.blue)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconContainer, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubview(container)
        container.addSubview(stack)
        iconContainer.addSubview(icon)
        
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
                
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconContainer.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.center.equalToSuperview()
        }
    }
    
    func configureCell(reminder: Reminder) {
        titleLabel.text = reminder.title
        icon.image = UIImage(systemName: reminder.reminderType.iconName)
    }
}

extension MainTableViewCell {
    static var reuseIdentifer: String {
        "\(self)"
    }
}
