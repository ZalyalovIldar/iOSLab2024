//
//  WatchListTableViewCell.swift
//  Movies
//
//  Created by Павел Калинин on 28.12.2024.
//

import UIKit

class WatchListCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return label
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.descriptionColor
        label.text = "2021"
        return label
    }()
    
    private lazy var yearIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = AppColors.descriptionColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.descriptionColor
        label.text = "100"
        return label
    }()
    
    private lazy var durationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = AppColors.descriptionColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.descriptionColor
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var genreIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film")
        imageView.tintColor = AppColors.descriptionColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var ratingIcon: UIImageView = {
        let imageView = UIImageView(image: .star)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.ratingColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let yearStack = UIStackView(arrangedSubviews: [yearIcon, yearLabel])
        yearStack.axis = .horizontal
        yearStack.spacing = 4
        
        let durationStack = UIStackView(arrangedSubviews: [durationIcon, durationLabel])
        durationStack.axis = .horizontal
        durationStack.spacing = 4
        
        let genreStack = UIStackView(arrangedSubviews: [genreIcon, genreLabel])
        genreStack.axis = .horizontal
        genreStack.spacing = 4
        
        let ratingStack = UIStackView(arrangedSubviews: [ratingIcon, ratingLabel])
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, ratingStack, genreStack, yearStack, durationStack])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(posterImageView)
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 95),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            mainStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    private func minutesWord(for minutes: Int) -> String {
        let remainder10 = minutes % 10
        let remainder100 = minutes % 100

        if remainder100 >= 11 && remainder100 <= 14 {
            return "\(minutes) минут"
        }

        switch remainder10 {
        case 1:
            return "\(minutes) минута"
        case 2...4:
            return "\(minutes) минуты"
        default:
            return "\(minutes) минут"
        }
    }
    
    private func genreList(genres: [Genre]) -> String {
        let string = "\(String(describing: genres[0].name))"
        return genres.count > 1 ? string + " и др." : string
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        genreLabel.text = genreList(genres: movie.genres ?? [])
        yearLabel.text = String(describing: movie.yearOfPublication!)
        durationLabel.text = minutesWord(for: movie.runningTime ?? 0)
        ratingLabel.text = String(describing: movie.rating ?? 0.0)
        Task {
            posterImageView.image = (try? await ImageService.shared.downloadImage(url: movie.poster.image)) ?? .default
        }
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
}

extension WatchListCollectionViewCell {
    static let reuseIdentifier = "WatchListTableViewCell"
}
