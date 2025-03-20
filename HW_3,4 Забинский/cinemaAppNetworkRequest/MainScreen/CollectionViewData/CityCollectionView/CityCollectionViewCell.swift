//
//  CityCollectionViewCell.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 26.12.2024.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    private lazy var grayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.tiny / 1.5
        view.clipsToBounds = true
        view.backgroundColor = Colors.lighterGray
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: Fonts.small)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
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
        title.text = city.name
        if isHighlighted {
            grayView.backgroundColor = .systemGray6
        } else {
            grayView.backgroundColor = Colors.lighterGray
        }
    }
    
    private func setup() {
        grayView.addSubview(title)
        addSubview(grayView)
        
        NSLayoutConstraint.activate([
            grayView.topAnchor.constraint(equalTo: self.topAnchor),
            grayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            grayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            title.topAnchor.constraint(equalTo: grayView.topAnchor, constant: Constants.nothing),
            title.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: Constants.nothing),
            title.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -Constants.nothing),
            title.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -Constants.nothing),
        ])
    }
}

extension CityCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}
