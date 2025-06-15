//
//  ThirdUITableViewCell.swift
//  homeWork1
//
//  Created by Данил Забинский on 26.09.2024.
//

import UIKit

class ThirdUITableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var titleUILabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configureWithUser(from user: User) {
        let userPhotos = user.information
        
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        userPhotos.enumerated().forEach { (index, photo) in
            let image = UIImageView(image: photo)
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 5

            contentStackView.addArrangedSubview(image)
            
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: 100),
                image.heightAnchor.constraint(equalTo: image.widthAnchor),
                
                image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])
        }
    }
    
    // MARK: - Private Methods
    private func setUp() {
        setUpTitleLabelText()
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        contentView.addSubview(titleUILabel)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            titleUILabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleUILabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleUILabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: titleUILabel.bottomAnchor, constant: 10),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setUpTitleLabelText() {
        titleUILabel.text = "Портфолио"
    }
    
}
