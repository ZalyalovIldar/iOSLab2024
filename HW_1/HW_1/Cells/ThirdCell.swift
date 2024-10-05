//
//  ThirdCell.swift
//  HW_1
//
//  Created by Ильнур Салахов on 04.10.2024.
//

import UIKit

class ThirdCell: UITableViewCell {

    lazy var photoTitleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.text = "Фото"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let scrollView = UIScrollView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoTitleLabel)
            setupScrollView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
            contentView.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                photoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
                photoTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                
                scrollView.topAnchor.constraint(equalTo: photoTitleLabel.bottomAnchor, constant: 10),
                scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -90),
                scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10 )
            ])

        }
    func configure(with images: [UIImage]) {
        let imageWidth = self.bounds.width
        let imageHeight = self.bounds.height
        let imageSpacing: CGFloat = -210

        scrollView.subviews.forEach { $0.removeFromSuperview() }

        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            let xPosition = CGFloat(index) * (imageWidth + imageSpacing)
            imageView.frame = CGRect(x: xPosition, y: 0, width: imageWidth, height: imageHeight)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: (imageWidth + imageSpacing) * CGFloat(images.count) - imageSpacing, height: imageHeight)
    }

}
