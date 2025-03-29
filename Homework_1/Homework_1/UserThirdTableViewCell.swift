//
//  UserThirdTableViewCell.swift
//  Homework_1
//
//  Created by Дмитрий Леонтьев on 02.10.2024.
//

import UIKit

class UserThirdTableViewCell: UITableViewCell {
    
    static let identifier: String = "UserThirdTableViewCell"
    
    private lazy var thirdTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var photo: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    func configureCell(with user: User){
        
        imageStackView.arrangedSubviews.forEach { view in
            imageStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for photo in user.photo{
            let imageView = UIImageView(image: photo)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            imageStackView.addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 250),
                imageView.heightAnchor.constraint(equalToConstant: 250)
            ])
        }
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        contentView.addSubview(thirdTitle)
        contentView.addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
        
        thirdTitle.text = "Фото"
        thirdTitle.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        
    }
    
    private func setUpLayout(){
        thirdTitle.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            thirdTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            thirdTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageScrollView.topAnchor.constraint(equalTo: thirdTitle.bottomAnchor, constant: 10),
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageScrollView.heightAnchor.constraint(equalToConstant: 250),
            
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor)
        ])
    }
}
