//
//  Label.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 06.04.2025.
//

import UIKit

class Label: UILabel {
    private var numberOfLinesLabel: Int
    private var sizeFont: CGFloat
    private var fontWeight: UIFont.Weight
    
    init(numberOfLinesLabel: Int, sizeFont: CGFloat, fontWeight: UIFont.Weight) {
        self.sizeFont = sizeFont
        self.numberOfLinesLabel = numberOfLinesLabel
        self.fontWeight = fontWeight
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        textAlignment = .left
        numberOfLines = numberOfLinesLabel
        font = UIFont.systemFont(ofSize: sizeFont, weight: fontWeight)
    }
}
