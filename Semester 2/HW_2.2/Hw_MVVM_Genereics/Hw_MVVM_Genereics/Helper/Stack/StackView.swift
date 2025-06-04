//
//  StackView.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 07.04.2025.
//

import UIKit

class StackView: UIStackView {
    
    private var views: [UIView]
    
    private var stackAxis: NSLayoutConstraint.Axis
    
    private var stackSpaicing: CGFloat
    
    private var stackAligment: UIStackView.Alignment
    
    init(views: [UIView], stackAxis: NSLayoutConstraint.Axis, stackSpaicing: CGFloat = 10,
         stackAligment: UIStackView.Alignment = .fill) {
        self.views = views
        self.stackAxis = stackAxis
        self.stackSpaicing = stackSpaicing
        self.stackAligment = stackAligment
        super.init(frame: .zero)
        setupStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack() {
        translatesAutoresizingMaskIntoConstraints = false
        views.forEach { addArrangedSubview($0) }
        axis = stackAxis
        spacing = stackSpaicing
        alignment = stackAligment
    }
}
