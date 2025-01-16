//
//  CityCollectionViewCell.swift
//  Films
//
//  Created by Артур Мавликаев on 12.01.2025.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CityCell"
    lazy var CityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 2
        label.isHighlighted = true
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    private func setupCell() {
        contentView.addSubview(CityLabel)
        contentView.backgroundColor = .darkGray.withAlphaComponent(0.5)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.cornerRadius = 10
        CityLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            CityLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            CityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            CityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            CityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
        
    }
     func configure(with city: CityModel) {
         CityLabel.text = city.name
    }
}
