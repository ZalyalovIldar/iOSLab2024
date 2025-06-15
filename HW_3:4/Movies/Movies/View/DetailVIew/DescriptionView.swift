//
//  DescriptionView.swift
//  Movies
//
//  Created by Павел Калинин on 25.12.2024.
//

import UIKit

class DescriptionView: UIView {
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.descriptionColor
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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var genreIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film")
        imageView.tintColor = AppColors.descriptionColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var separator1: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.descriptionColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    private lazy var separator2: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.descriptionColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let yearStack = UIStackView(arrangedSubviews: [yearIcon, yearLabel])
        yearStack.axis = .horizontal
        yearStack.spacing = 4
        
        let durationStack = UIStackView(arrangedSubviews: [durationIcon, durationLabel])
        durationStack.axis = .horizontal
        durationStack.spacing = 4
        
        let genreStack = UIStackView(arrangedSubviews: [genreIcon, genreLabel])
        genreStack.axis = .horizontal
        genreStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [yearStack, separator1, durationStack, separator2, genreStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)
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
        guard !genres.isEmpty else { return "-" }
        var string = ""
        for genre in genres {
            string += "\(String(describing: genre.name)), "
        }
        string.removeLast(2)
        return string
    }
    
    func configure(with movie: Movie) {
        if let yearOfPublication = movie.yearOfPublication {
            yearLabel.text = "\(String(describing: yearOfPublication))"
        }
        durationLabel.text = "\(minutesWord(for: movie.runningTime ?? 0))"
        genreLabel.text = genreList(genres: movie.genres ?? [])
    }
}
