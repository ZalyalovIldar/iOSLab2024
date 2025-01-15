//
//  InputView.swift
//  Movies
//
//  Created by Павел Калинин on 20.12.2024.
//

import UIKit

class SearchView: UIView {
    weak var searchIconDelegate: SearchIconDelegate?
    
    private lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView(image: UIImage.searchView.withRenderingMode(.alwaysTemplate))
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        return searchIcon
    }()
    
    private lazy var iconContainer: UIView = {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconContainer.addSubview(searchIcon)
        iconContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchIconTapped)))
        return iconContainer
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.backgroundColor = AppColors.searchGray
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Искать",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.titleGray]
        )
        
        textField.rightView = iconContainer
        textField.rightViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        searchTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: private methods
    private func setupView() {
        addSubview(searchTextField)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    //MARK: public methods
    func getText() -> String {
        searchTextField.text ?? ""
    }
    
    @objc private func searchIconTapped() {
        searchIconDelegate?.findMovieByName(name: searchTextField.text ?? "")
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchIconTapped()
        textField.resignFirstResponder()
        return true
    }
}

protocol SearchIconDelegate: AnyObject {
    func findMovieByName(name: String)
}
