//
//  CustomSearchBar.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import UIKit

class CustomSearchBar: UIView {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Montserrat-Regular", size: Constant.Font.medium)
        textField.textColor = Color.textFieldTextColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var buttonSearch: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.setTitle(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = Color.customDarkGrey
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlaceholder(placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: Color.textFieldTextColor ?? UIColor.red,
                .font: UIFont(name: "Montserrat-Regular", size: Constant.Font.medium) ?? UIFont.systemFont(ofSize: 16)
        ])
    }
    
    func setupDelegate(delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    func setupIcon(icon: UIImage) {
        buttonSearch.setImage(icon, for: .normal)
    }
    
    func setupAction(action: UIAction) {
        buttonSearch.addAction(action, for: .touchUpInside)
    }
    
    private func setupLayout() {
        addSubview(textField)
        addSubview(buttonSearch)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraint.marginLarge),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraint.marginHuge),
            textField.trailingAnchor.constraint(equalTo: buttonSearch.leadingAnchor, constant: -Constant.Constraint.marginLarge),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Constraint.marginLarge),
            
            buttonSearch.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonSearch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraint.marginHuge),
            buttonSearch.heightAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            buttonSearch.widthAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge)
        ])
    }
}
