//
//  MovieCollectionViewCell.swift
//  films
//
//  Created by Кирилл Титов on 15.01.2025.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(named: "searchGray")
        return imageView
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "heart.fill")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .yellow
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yellow
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 1
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let genreStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "genre"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let yearStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "calendar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let durationStackView: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "clock"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    var onRemove: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "cellBackground")
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        setupUI()
        setupConstraints()
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func removeButtonTapped() {
        onRemove?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(removeButton)
        contentView.addSubview(titleLabel)
        
        // Добавляем стек-views в общий информационный стек
        infoStackView.addArrangedSubview(ratingStackView)
        infoStackView.addArrangedSubview(genreStackView)
        infoStackView.addArrangedSubview(yearStackView)
        infoStackView.addArrangedSubview(durationStackView)
        
        contentView.addSubview(infoStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 2/3),
            
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
            
            infoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            infoStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let rating = movie.imdb_rating {
            if let label = ratingStackView.arrangedSubviews.last as? UILabel {
                label.text = " \(rating)"
            }
        } else {
            if let label = ratingStackView.arrangedSubviews.last as? UILabel {
                label.text = " Нет рейтинга"
            }
        }
        if let genres = movie.genres, !genres.isEmpty {
            if let label = genreStackView.arrangedSubviews.last as? UILabel {
                label.text = " " + genres.map { $0.name }.joined(separator: ", ")
            }
        } else {
            if let label = genreStackView.arrangedSubviews.last as? UILabel {
                label.text = " Неизвестно"
            }
        }
        if let year = movie.year {
            if let label = yearStackView.arrangedSubviews.last as? UILabel {
                label.text = " \(year)"
            }
        } else {
            if let label = yearStackView.arrangedSubviews.last as? UILabel {
                label.text = " Неизвестно"
            }
        }
        if let duration = movie.running_time {
            if let label = durationStackView.arrangedSubviews.last as? UILabel {
                label.text = " \(duration) мин"
            }
        } else {
            if let label = durationStackView.arrangedSubviews.last as? UILabel {
                label.text = " Неизвестно"
            }
        }
        if let posterURL = URL(string: movie.poster.image) {
            loadImage(from: posterURL, into: posterImageView)
        } else {
            posterImageView.image = UIImage(named: "defaultPoster")
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "defaultPoster")
                }
                return
            }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}
