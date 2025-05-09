//
//  SegmentCell.swift
//  Movies
//
//  Created by Павел Калинин on 23.12.2024.
//
import UIKit

class CustomSegmentCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.searchGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            underlineView.heightAnchor.constraint(equalToConstant: 4),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        underlineView.isHidden = true
    }
    
    func animateSelection(isSelected: Bool) {
        UIView.animate(.linear) {
            self.underlineView.isHidden = !isSelected
            self.titleLabel.font = isSelected ? .systemFont(ofSize: 18) : .systemFont(ofSize: 16)
        }
    }

    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.font = isSelected ? .systemFont(ofSize: 18) : .systemFont(ofSize: 16)
        underlineView.isHidden = !isSelected
    }
}

extension CustomSegmentCell {
    static let reuseIdentifier = "CustomSegmentCell"
}
