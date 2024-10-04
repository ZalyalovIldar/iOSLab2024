//
//  PhotosTableViewCell.swift
//  Profiler
//
//  Created by Тимур Салахиев on 03.10.2024.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var firstImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photo_1")
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 300),
            image.heightAnchor.constraint(equalToConstant: 300),
        ])
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var secondImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photo_2")
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 300),
            image.heightAnchor.constraint(equalToConstant: 300),
        ])
        return image
    }()
    
    lazy var thirdImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photo_3")
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 300),
            image.heightAnchor.constraint(equalToConstant: 300),
        ])
        return image
    }()
    
    lazy var fourthImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photo_4")
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 300),
            image.heightAnchor.constraint(equalToConstant: 300),
        ])
        return image
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private func setupLayout(){
        contentView.addSubview(scrollView)
        
        stackView.addArrangedSubview(firstImageView)
        stackView.addArrangedSubview(secondImageView)
        stackView.addArrangedSubview(thirdImageView)
        stackView.addArrangedSubview(fourthImageView)

        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            //stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            //stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            //stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)

            
        ])
    }

}
