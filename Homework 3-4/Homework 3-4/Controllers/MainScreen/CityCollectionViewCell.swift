//
//  CityCollectionViewCell.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 17.01.2025.
//

import UIKit

final class CityCollectionViewCell: UICollectionViewCell {
    static let identifier = "CityCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.darkGray
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cityName: String) {
        titleLabel.text = cityName
    }

    override var intrinsicContentSize: CGSize {
        let width = titleLabel.intrinsicContentSize.width + 32
        let height = titleLabel.intrinsicContentSize.height + 20
        return CGSize(width: width, height: height)
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = self.isSelected ? UIColor.systemBlue : UIColor.darkGray
                self.titleLabel.textColor = self.isSelected ? .white : .lightGray
            }
        }
    }
    func animateAppearance(delay: TimeInterval = 0) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: [.curveEaseOut],
                       animations: {
                           self.alpha = 1
                           self.transform = .identity
                       },
                       completion: nil)
    }
}
