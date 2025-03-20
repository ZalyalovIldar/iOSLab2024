//
//  PhotoScrollViewTableViewCell.swift
//  Ex1
//
//  Created by Терёхин Иван on 04.10.2024.
//

import UIKit

class PhotoScrollViewTableViewCell: UITableViewCell {
    

    private lazy var photoScrollView: UIScrollView = {
        
        let scroll = UIScrollView()
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.showsVerticalScrollIndicator = true
        
        scroll.alwaysBounceVertical = true
    
        
        
        return scroll
        
    }()
    
    private lazy var stackView: UIStackView = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private func setupLayout(){
        
        contentView.addSubview(photoScrollView)
        photoScrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            photoScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: photoScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: photoScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: photoScrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: photoScrollView.bottomAnchor),
            
            stackView.heightAnchor.constraint(equalTo: photoScrollView.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: photoScrollView.widthAnchor)
        
        
        ])
        
    }
    
    func configure(with photos: [String]) {
        
        for photo in photos {
            let image = UIImageView(image: UIImage(named: photo))
            image.contentMode = .scaleAspectFit

            image.heightAnchor.constraint(equalToConstant: 200).isActive = true

            stackView.addArrangedSubview(image)
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
    
    
extension PhotoScrollViewTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    
}
