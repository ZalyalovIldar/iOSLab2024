//
//  TweetTableViewCell.swift
//  SwiftPM
//
//  Created by Damir Rakhmatullin on 22.03.25.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var userNameLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14, weight: .medium)
       return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private lazy var textDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
     }()
    private lazy var followersCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
      }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [userNameLabel, urlLabel, textDescriptionLabel, followersCountLabel])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 15
        return verticalStackView
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    public func configureCell(tweet: Tweet) {
        userNameLabel.text = tweet.userName
        urlLabel.text = tweet.url
        textDescriptionLabel.text = tweet.text
        followersCountLabel.text = String(tweet.followersCount)
    }

    private func setupLayout() {
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constraint.medium.rawValue),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Constraint.medium.rawValue)
        ])
    }
}

extension TweetTableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: TweetTableViewCell.self)
    }
}
