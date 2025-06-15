//
//  CustomSegmentControll.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 08.01.2025.
// я у нейронки спросил как делают это в компаниях и она мне сказала что делают отдельное вью и уже его только обновляют и добавляют анимации чтобы не загружать основное вью

import UIKit

protocol CustomSegmentControlDelegate: AnyObject {
    func changedIndex(index: Int)
}

class CustomSegmentControl: UIView {

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor(red: 25/255, green: 32/255, blue: 40/255, alpha: 1.0)
        segmentControl.selectedSegmentTintColor = .clear
        
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return segmentControl
    }()
    
    lazy var underlineView: UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = Color.customDarkGrey
        return underline
    }()
    
    weak var delegate: CustomSegmentControlDelegate?
    
    private lazy var action = UIAction { [weak self] _ in
        guard let self = self else { return }
        
        let underlineViewWidth = self.bounds.width / CGFloat (segmentControl.numberOfSegments)
        
        underlineLeadingConstraint.constant = underlineViewWidth * CGFloat(segmentControl.selectedSegmentIndex)
        
        self.delegate?.changedIndex(index: self.segmentControl.selectedSegmentIndex)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private var underlineLeadingConstraint: NSLayoutConstraint!
    
    private var underlineWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(_ items: [String]) {
        for (index, item) in items.enumerated() {
            segmentControl.insertSegment(withTitle: item, at: index, animated: false)
        }
        setupLayout()
        segmentControl.addAction(action, for: .valueChanged)
    }
        
    func updateLayout() {
        let segmentWidth = (self.bounds.width - safeAreaInsets.left - safeAreaInsets.right) / CGFloat(segmentControl.numberOfSegments)
        underlineWidthConstraint.constant = segmentWidth
       
        if segmentControl.selectedSegmentIndex == -1 {
            underlineLeadingConstraint.constant = 0
        } else {
            underlineLeadingConstraint.constant = segmentWidth * CGFloat(segmentControl.selectedSegmentIndex)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupLayout() {
        
        addSubview(segmentControl)
        addSubview(underlineView)
        
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalToConstant: self.bounds.width / CGFloat(segmentControl.numberOfSegments))
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.04),

            underlineView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Constant.Constraint.marginSmall),
            underlineView.heightAnchor.constraint(equalToConstant: 3),
            underlineLeadingConstraint,
            underlineWidthConstraint
        ])
    }
}
