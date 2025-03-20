//
//  NavigationItemView.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import UIKit

class NavigationItemView: UIView {

    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Fonts.big)
        label.textColor = .white
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        self.title.text = title
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
