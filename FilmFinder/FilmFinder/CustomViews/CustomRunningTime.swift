//
//  CustomRunningTime.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 06.01.2025.
//

import UIKit

class CustomRunningTime: UIView {
    private lazy var clockImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .clock))
        image.tintColor = Color.customGrey
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Constant.Font.small)
        label.textColor = Color.customGrey
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTime(runningTime: String) {
        timeLabel.text = runningTime
    }
    
    private func setupLayout() {
        addSubview(clockImage)
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            clockImage.heightAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            clockImage.widthAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            clockImage.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraint.marginSmall),
            clockImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraint.marginMedium),
            clockImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Constraint.marginSmall),
            
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: clockImage.trailingAnchor, constant: Constant.Constraint.marginTiny),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraint.marginMedium)
        ])
    }

}
