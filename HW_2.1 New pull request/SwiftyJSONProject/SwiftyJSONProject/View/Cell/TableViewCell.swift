//
//  TableViewCell.swift
//  SwiftyJSONProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    private lazy var customView: UIView = {
        let customView = UIView()
        customView.layer.cornerRadius = 14
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .secondarySystemBackground
        return customView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name: "
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age: "
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sexLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender: "
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var namePassanger: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agePassanger: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sexPassanger: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var survived: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let horizontalStackViewName = createStackView(arrangedSubviews: [nameLabel, namePassanger], axis: .horizontal, spacing: ConstantConstraint.little)
        let horizontalStackViewSex = createStackView(arrangedSubviews: [sexLabel, sexPassanger], axis: .horizontal, spacing: ConstantConstraint.little)
        let horizontalStackViewAge = createStackView(arrangedSubviews: [ageLabel, agePassanger], axis: .horizontal, spacing: ConstantConstraint.little)
        
        let stackView = UIStackView(arrangedSubviews: [horizontalStackViewName, horizontalStackViewSex, horizontalStackViewAge])
        stackView.axis = .vertical
        stackView.spacing = ConstantConstraint.medium
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verticalStackView, survived])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(passanger: Passenger) {
        namePassanger.text = passanger.name
        agePassanger.text = String(passanger.age)
        sexPassanger.text = passanger.sex
        if passanger.survived == 1 {
            survived.text = "Live"
            survived.textColor = .systemGreen
        } else {
            survived.text = "Dead"
            survived.textColor = .systemRed
        }
       
    }
    
    func setupSubviews() {
        contentView.addSubview(customView)
        customView.addSubview(horizontalStackView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ConstantConstraint.little),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstantConstraint.little),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ConstantConstraint.little),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ConstantConstraint.little),
            
            horizontalStackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: ConstantConstraint.medium),
            horizontalStackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: ConstantConstraint.medium),
            horizontalStackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -ConstantConstraint.medium),
            horizontalStackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -ConstantConstraint.medium)
        ])
    }
    
    func createStackView(arrangedSubviews: [UIView],
                         axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }
}

extension TableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
