//
//  CityCollectionViewCell.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Constant.Font.medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Constraint.marginSmall),
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginSmall),
            cityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginSmall),
            cityNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Constraint.marginSmall)
        ])
    }
    
    func configureCell(city: City) {
        self.cityNameLabel.text = city.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.attributedText = NSAttributedString(string: cityNameLabel.text!, attributes: [:])
    }
    
    func underlineText(state: Bool) {
        if state {
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.white
            ]
            cityNameLabel.attributedText = NSAttributedString(string: cityNameLabel.text!, attributes: attributes)
        } else {
            cityNameLabel.attributedText = NSAttributedString(string: cityNameLabel.text!, attributes: [:])
        }
    }
}

extension CityCollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
