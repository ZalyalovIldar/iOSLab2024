//
//  View.ext.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...)  {
        views.forEach {
            self.addSubview($0)
        }
    }
}
