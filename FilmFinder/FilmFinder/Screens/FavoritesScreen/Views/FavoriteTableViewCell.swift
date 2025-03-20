//
//  FavoriteTableViewCell.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    private lazy var imageMovie: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleMovie: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: Constant.Font.extraLarge)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingView: CustomRatingView = {
        let ratingView = CustomRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    private lazy var genreView: CustomGenreView = {
        let genreView = CustomGenreView()
        genreView.translatesAutoresizingMaskIntoConstraints = false
        return genreView
    }()
    
    private lazy var yearView: CustomYearView = {
        let yearView = CustomYearView()
        yearView.translatesAutoresizingMaskIntoConstraints = false
        return yearView
    }()
    
    private lazy var runningView: CustomRunningTime = {
        let runningView = CustomRunningTime()
        runningView.translatesAutoresizingMaskIntoConstraints = false
        return runningView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(ratingView)
        stackView.addArrangedSubview(genreView)
        stackView.addArrangedSubview(yearView)
        stackView.addArrangedSubview(runningView)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.backgroundColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(movie: MovieEntity) {
        
        titleMovie.text = movie.title
        if let dataImage = movie.poster {
            imageMovie.image = UIImage(data: dataImage)
        }
        
        if let genre = movie.genre {
            genreView.setGenre(genre: genre)
        }
        
        ratingView.setRating(rating: String(movie.rating))
        yearView.setYear(year: String(movie.year))
        runningView.setTime(runningTime: "\(movie.runningTime) минут")
    }
    
    private func setupLayout() {
        contentView.addSubview(imageMovie)
        contentView.addSubview(titleMovie)
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            imageMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Constraint.marginExtraLarge),
            imageMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraint.marginExtraLarge),
            imageMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Constraint.marginExtraLarge),
            imageMovie.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.35),
            
            titleMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Constraint.marginExtraLarge),
            titleMovie.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: Constant.Constraint.marginExtraLarge),
            titleMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginExtraLarge),
            
            verticalStackView.topAnchor.constraint(equalTo: titleMovie.bottomAnchor, constant: Constant.Constraint.marginExtraLarge),
            verticalStackView.leadingAnchor.constraint(equalTo: titleMovie.leadingAnchor),
            
        ])
    }
}

extension FavoriteTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
