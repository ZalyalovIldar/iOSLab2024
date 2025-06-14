//
//  ReminderTableViewCell.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//


import UIKit

final class ReminderTableViewCell: UITableViewCell {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let shadowOpacity: Float = 0.15
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowRadius: CGFloat = 4
        
        static let titleFontSize: CGFloat = 17
        static let subtitleFontSize: CGFloat = 14
        static let timeFontSize: CGFloat = 14
        
        static let cellPadding: CGFloat = 8
        static let innerPadding: CGFloat = 12
        static let spacing: CGFloat = 8
        static let timeMinWidth: CGFloat = 60
    }

    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = Constants.shadowOpacity
        view.layer.shadowOffset = Constants.shadowOffset
        view.layer.shadowRadius = Constants.shadowRadius
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.subtitleFontSize, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: Constants.timeFontSize, weight: .regular)
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with reminder: Reminder) {
        titleLabel.text = reminder.title
        typeLabel.text = reminder.type.rawValue
        timeLabel.text = reminder.date.formatted(date: .omitted, time: .shortened)
    }

    // MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.cellPadding)
        ])
        
        [titleLabel, typeLabel, timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.innerPadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -Constants.spacing),

            typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.innerPadding),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerPadding),
            typeLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -Constants.spacing),

            timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerPadding),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.timeMinWidth)
        ])
    }
}

extension ReminderTableViewCell {
    static let reuseIdentifier = "ReminderTableViewCell"
}

extension ReminderTableViewCell {
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        let transform: CGAffineTransform = highlighted
        ? CGAffineTransform(scaleX: 0.97, y: 0.97)
        : .identity
        
        let alpha: CGFloat = highlighted ? 0.9 : 1.0
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.3,
                           options: [.curveEaseInOut, .allowUserInteraction]) {
                self.containerView.transform = transform
                self.containerView.alpha = alpha
            }
        } else {
            containerView.transform = transform
            containerView.alpha = alpha
        }
    }
}
