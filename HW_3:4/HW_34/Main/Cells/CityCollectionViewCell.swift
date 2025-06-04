//
//  CityCollectionViewCell.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {

    private lazy var cityTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: FontConstants.big)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithCity(_ city: City, isHighlighted: Bool) {
        cityTitleLabel.text = city.name
        self.layer.cornerRadius = SpacingConstants.tiny
        if isHighlighted {
            cityTitleLabel.font = UIFont(name: "Poppins-Black", size: FontConstants.big)
            cityTitleLabel.textColor = .white
            self.backgroundColor = .systemGray
        } else {
            cityTitleLabel.font = UIFont(name: "Poppins-Regular", size: FontConstants.big)
            cityTitleLabel.textColor = .systemGray
            self.backgroundColor = .clear
        }
    }

    private func setup() {
        addSubview(cityTitleLabel)

        NSLayoutConstraint.activate([
            cityTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            cityTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cityTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cityTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension CityCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}
