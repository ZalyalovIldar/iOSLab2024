//
//  TrailerButtonTableViewCell.swift
//  Films
//
//  Created by Артур Мавликаев on 11.01.2025.
//

import UIKit

final class TrailerButtonCell: UITableViewCell {
    static let identifier = "TrailerButtonCell"

    var onTrailerButtonTap: (
    () -> Void
    )?
    
    let trailerButton: UIButton = {
        let button = UIButton(
            type: .system
        )
        button
            .setTitle(
                "Смотреть трейлер",
                for: .normal
            )
        button.titleLabel?.font = UIFont
            .boldSystemFont(
                ofSize: 18
            )
        button
            .setTitleColor(
                .white,
                for: .normal
            ) 
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gray
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(
            width: 0,
            height: 4
        )
        button.layer.shadowRadius = 8
        
        return button
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        contentView
            .addSubview(
                trailerButton
            )
        
        trailerButton
            .addTarget(
                self,
                action: #selector(
                    buttonTapped
                ),
                for: .touchUpInside
            )
        
        NSLayoutConstraint
            .activate(
                [
                    trailerButton.topAnchor
                        .constraint(
                            equalTo: contentView.topAnchor,
                            constant: 20
                        ),
                    trailerButton.centerXAnchor
                        .constraint(
                            equalTo: contentView.centerXAnchor
                        ),
                    trailerButton.bottomAnchor
                        .constraint(
                            equalTo: contentView.bottomAnchor,
                            constant: -20
                        ),
                    trailerButton.heightAnchor
                        .constraint(
                            equalToConstant: 50
                        ),
                    trailerButton.widthAnchor
                        .constraint(
                            equalToConstant: 200
                        )
                ]
            )
    }
    
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    @objc private func buttonTapped() {
        onTrailerButtonTap?()
    }
}
