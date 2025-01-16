//
//  CustomYearView.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 06.01.2025.
//

import UIKit

class CustomYearView: UIView {

    private lazy var calendarImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .calendarBlank))
        image.tintColor = Color.customGrey
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var yearLabel: UILabel = {
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
    
    func setYear(year: String) {
        yearLabel.text = year
    }
    
    private func setupLayout() {
        addSubview(calendarImage)
        addSubview(yearLabel)
        NSLayoutConstraint.activate([
            calendarImage.heightAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            calendarImage.widthAnchor.constraint(equalToConstant: Constant.Constraint.marginHuge),
            calendarImage.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraint.marginSmall),
            calendarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraint.marginMedium),
            calendarImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Constraint.marginSmall),
            
            yearLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: calendarImage.trailingAnchor, constant: Constant.Constraint.marginTiny),
            yearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraint.marginMedium)
        ])
    }


}
