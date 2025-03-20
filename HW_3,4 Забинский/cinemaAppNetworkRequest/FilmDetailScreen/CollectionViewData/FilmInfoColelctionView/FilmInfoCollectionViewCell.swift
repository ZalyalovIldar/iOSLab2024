//
//  FilmInfoCollectionViewCell.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 03.01.2025.
//

import UIKit

class FilmInfoCollectionViewCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Fonts.title)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithTitle(title: String, isHighlighted: Bool) {
        label.text = title
        if isHighlighted {
            label.textColor = .systemGray6
        } else {
            label.textColor = Colors.lighterGray
        }
    }
    
    private func setup() {
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}

extension FilmInfoCollectionViewCell {
    static var identifies: String {
        "\(self)"
    }
}
