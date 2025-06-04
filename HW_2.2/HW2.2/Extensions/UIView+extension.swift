//
//  UIView+extension.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import UIKit

extension UIView {
    
    func edges(to view: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
}
